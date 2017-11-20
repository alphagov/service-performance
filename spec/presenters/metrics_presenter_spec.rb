require 'rails_helper'

RSpec.describe MetricsPresenter do
  let(:entity) { double(:entity) }
  let(:client) { instance_double(GovernmentServiceDataAPI::Client) }
  let(:group_by) { Metrics::Group::Department }
  let(:order) { nil }
  let(:order_by) { nil }
  let(:presenter) { described_class.new(entity, client: client, group_by: group_by, order: order, order_by: order_by) }

  describe '#initialize' do
    it 'defaults to Descending order when none provided' do
      presenter = described_class.new(entity, client: client, group_by: group_by)
      expect(presenter.order).to eq(Metrics::Order::Descending)

      presenter = described_class.new(entity, client: client, group_by: group_by, order: nil)
      expect(presenter.order).to eq(Metrics::Order::Descending)
    end

    it 'defaults to ordering by name, when none provided' do
      presenter = described_class.new(entity, client: client, group_by: group_by)
      expect(presenter.selected_metric_sort_attribute).to eq(Metrics::Items::Name)

      presenter = described_class.new(entity, client: client, group_by: group_by, order_by: nil)
      expect(presenter.selected_metric_sort_attribute).to eq(Metrics::Items::Name)
    end

    it 'allows setting order' do
      presenter = described_class.new(entity, client: client, group_by: group_by, order: Metrics::Order::Descending)
      expect(presenter.order).to eq(Metrics::Order::Descending)
    end

    it 'allows setting order by' do
      presenter = described_class.new(entity, client: client, group_by: group_by, order_by: Metrics::Items::TransactionsReceived.identifier)
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
    let(:totals) { instance_double(GovernmentServiceDataAPI::MetricGroup) }
    let(:totals_metric_presenter) { instance_double(MetricGroupPresenter, "totals metric presenter") }

    before do
      allow(MetricGroupPresenter::Totals).to receive(:new).with(totals, hash_including(:collapsed)) { totals_metric_presenter }
    end

    it 'fetches the metric groups with the `group_by` parameter' do
      expect(client).to receive(:metrics).with(entity, group_by: group_by) { instance_double(GovernmentServiceDataAPI::Metrics, totals: totals, metric_groups: []) }
      presenter.metric_groups
    end

    it 'wraps each metric group in a MetricGroupPresenter' do
      metric_group_one = instance_double(GovernmentServiceDataAPI::MetricGroup)
      metric_group_two = instance_double(GovernmentServiceDataAPI::MetricGroup)
      allow(metric_group_one).to receive(:entity) { double(name: "test1") }
      allow(metric_group_two).to receive(:entity) { double(name: "test2") }
      allow(client).to receive(:metrics) { instance_double(GovernmentServiceDataAPI::Metrics, totals: totals, metric_groups: [metric_group_one, metric_group_two]) }

      metric_group_presenter_one = instance_double(MetricGroupPresenter)
      metric_group_presenter_two = instance_double(MetricGroupPresenter)
      allow(metric_group_presenter_one).to receive(:sort_value) { "test1" }
      allow(metric_group_presenter_two).to receive(:sort_value) { "test2" }
      allow(metric_group_presenter_one).to receive(:has_sort_value?) { true }
      allow(metric_group_presenter_two).to receive(:has_sort_value?) { true }

      expect(MetricGroupPresenter).to receive(:new).with(metric_group_one, collapsed: false, sort_value: "test1") { metric_group_presenter_one }
      expect(MetricGroupPresenter).to receive(:new).with(metric_group_two, collapsed: false, sort_value: "test2") { metric_group_presenter_two }

      expect(presenter.metric_groups).to match_array([totals_metric_presenter, metric_group_presenter_one, metric_group_presenter_two])
    end

    it "sets the metric group to be collapsed if it isn't ordered by name" do
      metric_group = instance_double(GovernmentServiceDataAPI::MetricGroup)
      allow(metric_group).to receive(:entity) { double(name: "test1") }

      allow(client).to receive(:metrics) { instance_double(GovernmentServiceDataAPI::Metrics, totals: totals, metric_groups: [metric_group]) }

      expect(MetricGroupPresenter).to receive(:new).with(metric_group, collapsed: false, sort_value: "test1") { instance_double(MetricGroupPresenter, sort_value: "test", has_sort_value?: true) }

      presenter = described_class.new(entity, client: client, group_by: group_by, order_by: 'alternative metric')
      presenter.metric_groups
    end

    describe 'sorting' do
      let(:metric_groups) {
        4.times.map { |idx|
          instance_double(GovernmentServiceDataAPI::MetricGroup, entity: double(name: "test#{idx}"))
        }
      }
      let(:metric_group_presenters) {
        4.times.map { |idx|
          instance_double(MetricGroupPresenter, sort_value: "test#{idx}", has_sort_value?: true)
        }
      }

      before do
        allow(client).to receive(:metrics) { instance_double(GovernmentServiceDataAPI::Metrics, totals: totals, metric_groups: metric_groups) }
        allow(MetricGroupPresenter).to receive(:new).and_return(*metric_group_presenters)
      end

      it 'sorts the metric groups, according to order by' do
        presenter = described_class.new(entity, client: client, group_by: group_by, order: Metrics::Order::Descending)
        expect(presenter.metric_groups).to eq([totals_metric_presenter, metric_group_presenters[0], metric_group_presenters[1], metric_group_presenters[2], metric_group_presenters[3]])
      end

      it 'reverses the order, if order is ascending' do
        presenter = described_class.new(entity, client: client, group_by: group_by, order: Metrics::Order::Ascending)
        expect(presenter.metric_groups).to eq([totals_metric_presenter, metric_group_presenters[3], metric_group_presenters[2], metric_group_presenters[1], metric_group_presenters[0]])
      end
    end

    describe 'totals metrics group presenter' do
      let(:metric_groups) {
        dbl = instance_double(GovernmentServiceDataAPI::MetricGroup, transactions_received: double(total: 100))
        allow(dbl).to receive(:entity) { double(name: "test") }
        [dbl]
      }
      let(:metric_group_presenter) { instance_double(MetricGroupPresenter, sort_value: 100, has_sort_value?: true) }

      before do
        allow(client).to receive(:metrics) { instance_double(GovernmentServiceDataAPI::Metrics, totals: totals, metric_groups: metric_groups) }
        allow(MetricGroupPresenter).to receive(:new).and_return(metric_group_presenter)
      end

      it 'is prepended when ordered by name' do
        presenter = presenter(order_by: Metrics::Items::Name.identifier, order: Metrics::Order::Ascending)
        expect(presenter.metric_groups).to eq([totals_metric_presenter, metric_group_presenter])

        presenter = presenter(order_by: Metrics::Items::Name.identifier, order: Metrics::Order::Descending)
        expect(presenter.metric_groups).to eq([totals_metric_presenter, metric_group_presenter])
      end

      it 'is prepended when ordered by descending' do
        presenter = presenter(order_by: Metrics::Items::TransactionsReceived.identifier, order: Metrics::Order::Descending)
        expect(presenter.metric_groups).to eq([totals_metric_presenter, metric_group_presenter])
      end

      it 'is appended when ordered by ascending' do
        presenter = presenter(order_by: Metrics::Items::TransactionsReceived.identifier, order: Metrics::Order::Ascending)
        expect(presenter.metric_groups).to eq([metric_group_presenter, totals_metric_presenter])
      end

      def presenter(order_by:, order:)
        @presenter ||= described_class.new(entity, client: client, group_by: group_by, order_by: order_by, order: order)
      end
    end
  end

  describe '#has_departments?' do
    it { expect(presenter).to have_departments }
  end

  describe '#has_delivery_organisations?' do
    it { expect(presenter).to have_delivery_organisations }
  end

  describe '#has_services?' do
    it { expect(presenter).to have_services }
  end

  describe '#departments_count' do
    it 'delegates to the entity' do
      allow(entity).to receive(:departments_count) { 12 }
      expect(presenter.departments_count).to eq(12)
    end
  end

  describe '#delivery_organisations_count' do
    it 'delegates to the entity' do
      allow(entity).to receive(:delivery_organisations_count) { 12 }
      expect(presenter.delivery_organisations_count).to eq(12)
    end
  end

  describe '#services_count' do
    it 'delegates to the entity' do
      allow(entity).to receive(:services_count) { 12 }
      expect(presenter.services_count).to eq(12)
    end
  end
end
