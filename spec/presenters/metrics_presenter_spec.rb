require 'rails_helper'

RSpec.describe MetricsPresenter do
  let(:entity) { double(:entity) }
  let(:group_by) { Metrics::GroupBy::Department }
  let(:order) { nil }
  let(:order_by) { nil }
  let(:presenter) { described_class.new(entity, group_by: group_by, order: order, order_by: order_by) }

  describe '#initialize' do
    it 'defaults to Descending order when none provided' do
      presenter = described_class.new(entity, group_by: group_by)
      expect(presenter.order).to eq(Metrics::Order::Descending)

      presenter = described_class.new(entity, group_by: group_by, order: nil)
      expect(presenter.order).to eq(Metrics::Order::Descending)
    end

    it 'defaults to ordering by name, when none provided' do
      presenter = described_class.new(entity, group_by: group_by)
      expect(presenter.selected_metric_sort_attribute).to eq(Metrics::Items::Name)

      presenter = described_class.new(entity, group_by: group_by, order_by: nil)
      expect(presenter.selected_metric_sort_attribute).to eq(Metrics::Items::Name)
    end

    it 'allows setting order' do
      presenter = described_class.new(entity, group_by: group_by, order: Metrics::Order::Descending)
      expect(presenter.order).to eq(Metrics::Order::Descending)
    end

    it 'allows setting order by' do
      presenter = described_class.new(entity, group_by: group_by, order_by: Metrics::Items::TransactionsReceived.identifier)
      expect(presenter.selected_metric_sort_attribute).to eq(Metrics::Items::TransactionsReceived)
    end
  end

  describe '#organisation_name' do
    it 'delegates to the entity' do
      allow(entity).to receive(:name) { 'name' }
      expect(presenter.organisation_name).to eq('name')
    end
  end

  describe '#metric_groups' do
    let(:totals_metric_presenter) { instance_double(MetricGroupPresenter, "totals metric presenter") }

    let(:metric_group) { instance_double(Metrics::MetricGroup) }
    let(:data) { double('Metrics', totals_metric_group: double('totals metric group'), metric_groups: [metric_group]) }

    before do
      allow(presenter).to receive(:data) { data }
      allow(MetricGroupPresenter::Totals).to receive(:new) { totals_metric_presenter }
    end

    it 'wraps each metric group in a MetricGroupPresenter' do
      metric_group_one = instance_double(Metrics::MetricGroup, entity: double(name: "test1"))
      metric_group_two = instance_double(Metrics::MetricGroup, entity: double(name: "test2"))
      allow(data).to receive(:metric_groups) { [metric_group_one, metric_group_two] }

      metric_group_presenter_one = instance_double(MetricGroupPresenter, has_sort_value?: true, sort_value: "test1")
      metric_group_presenter_two = instance_double(MetricGroupPresenter, has_sort_value?: true, sort_value: "test2")

      expect(MetricGroupPresenter).to receive(:new).with(metric_group_one, collapsed: false, sort_value: "test1") { metric_group_presenter_one }
      expect(MetricGroupPresenter).to receive(:new).with(metric_group_two, collapsed: false, sort_value: "test2") { metric_group_presenter_two }

      expect(presenter.metric_groups).to match_array([totals_metric_presenter, metric_group_presenter_one, metric_group_presenter_two])
    end

    it "sets the metric group to be collapsed if it isn't ordered by name" do
      allow(metric_group).to receive(:entity) { double(name: "test1") }

      expect(MetricGroupPresenter).to receive(:new).with(metric_group, collapsed: false, sort_value: "test1") { instance_double(MetricGroupPresenter, sort_value: "test", has_sort_value?: true) }

      presenter = described_class.new(entity, group_by: group_by, order_by: 'alternative metric')
      allow(presenter).to receive(:data) { data }
      presenter.metric_groups
    end

    describe 'sorting' do
      let(:metric_groups) {
        4.times.map { |idx|
          instance_double(Metrics::MetricGroup, entity: double(name: "test#{idx}"))
        }
      }
      let(:metric_group_presenters) {
        4.times.map { |idx|
          instance_double(MetricGroupPresenter, sort_value: "test#{idx}", has_sort_value?: true)
        }
      }

      before do
        allow(data).to receive(:totals) { totals }
        allow(data).to receive(:metric_groups) { metric_groups }
        allow(MetricGroupPresenter).to receive(:new).and_return(*metric_group_presenters)
      end

      it 'sorts the metric groups, according to order by' do
        presenter = described_class.new(entity, group_by: group_by, order: Metrics::Order::Descending)
        allow(presenter).to receive(:data) { data }
        expect(presenter.metric_groups).to eq([totals_metric_presenter, metric_group_presenters[0], metric_group_presenters[1], metric_group_presenters[2], metric_group_presenters[3]])
      end

      it 'reverses the order, if order is ascending' do
        presenter = described_class.new(entity, group_by: group_by, order: Metrics::Order::Ascending)
        allow(presenter).to receive(:data) { data }
        expect(presenter.metric_groups).to eq([totals_metric_presenter, metric_group_presenters[3], metric_group_presenters[2], metric_group_presenters[1], metric_group_presenters[0]])
      end
    end

    describe 'totals metrics group presenter' do
      let(:metric_groups) {
        dbl = instance_double(Metrics::MetricGroup, transactions_received_metric: double(total: 100))
        allow(dbl).to receive(:entity) { double(name: "test") }
        [dbl]
      }
      let(:metric_group_presenter) { instance_double(MetricGroupPresenter, sort_value: 100, has_sort_value?: true) }

      before do
        allow(MetricGroupPresenter).to receive(:new).and_return(metric_group_presenter)
        allow(data).to receive(:metric_groups) { metric_groups }
      end

      it 'is prepended when ordered by name' do
        presenter = build_presenter(order_by: Metrics::Items::Name.identifier, order: Metrics::Order::Ascending)
        expect(presenter.metric_groups).to eq([totals_metric_presenter, metric_group_presenter])

        presenter = build_presenter(order_by: Metrics::Items::Name.identifier, order: Metrics::Order::Descending)
        expect(presenter.metric_groups).to eq([totals_metric_presenter, metric_group_presenter])
      end

      it 'is prepended when ordered by descending' do
        presenter = build_presenter(order_by: Metrics::Items::TransactionsReceived.identifier, order: Metrics::Order::Descending)
        expect(presenter.metric_groups).to eq([totals_metric_presenter, metric_group_presenter])
      end

      it 'is appended when ordered by ascending' do
        presenter = build_presenter(order_by: Metrics::Items::TransactionsReceived.identifier, order: Metrics::Order::Ascending)
        expect(presenter.metric_groups).to eq([metric_group_presenter, totals_metric_presenter])
      end

      def build_presenter(order_by:, order:)
        @presenter ||= begin
          described_class.new(entity, group_by: group_by, order_by: order_by, order: order).tap do |presenter|
            allow(presenter).to receive(:data) { data }
          end
        end
      end
    end
  end

  context 'with departments association' do
    before do
      allow(entity).to receive(:respond_to?).with(:departments) { true }
    end

    it { expect(presenter).to have_departments }

    it 'delegates count to the entity' do
      allow(entity).to receive(:departments_count) { 12 }
      expect(presenter.departments_count).to eq(12)
    end
  end

  context 'without departments assocation' do
    before do
      allow(entity).to receive(:respond_to?).with(:departments) { false }
    end

    it { expect(presenter).to_not have_departments }

    it 'delegates count to the entity' do
      expect(presenter.departments_count).to be_nil
    end
  end

  context 'with delivery_organisations association' do
    before do
      allow(entity).to receive(:respond_to?).with(:delivery_organisations) { true }
    end

    it { expect(presenter).to have_delivery_organisations }

    it 'delegates count to the entity' do
      allow(entity).to receive(:delivery_organisations_count) { 12 }
      expect(presenter.delivery_organisations_count).to eq(12)
    end
  end

  context 'without delivery_organisations assocation' do
    before do
      allow(entity).to receive(:respond_to?).with(:delivery_organisations) { false }
    end

    it { expect(presenter).to_not have_delivery_organisations }

    it 'delegates count to the entity' do
      expect(presenter.delivery_organisations_count).to be_nil
    end
  end

  context 'with services association' do
    before do
      allow(entity).to receive(:respond_to?).with(:services) { true }
    end

    it { expect(presenter).to have_services }

    it 'delegates count to the entity' do
      allow(entity).to receive(:services_count) { 12 }
      expect(presenter.services_count).to eq(12)
    end
  end

  context 'without services assocation' do
    before do
      allow(entity).to receive(:respond_to?).with(:services) { false }
    end

    it { expect(presenter).to_not have_services }

    it 'delegates count to the entity' do
      expect(presenter.services_count).to be_nil
    end
  end
end
