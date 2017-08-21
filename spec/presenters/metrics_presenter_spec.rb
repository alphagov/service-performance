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
      expect(presenter.order_by).to eq(Metrics::OrderBy::Name.identifier)

      presenter = described_class.new(entity, client: client, group_by: group_by, order_by: nil)
      expect(presenter.order_by).to eq(Metrics::OrderBy::Name.identifier)
    end

    it 'allows setting order' do
      presenter = described_class.new(entity, client: client, group_by: group_by, order: Metrics::Order::Descending)
      expect(presenter.order).to eq(Metrics::Order::Descending)
    end

    it 'allows setting order by' do
      presenter = described_class.new(entity, client: client, group_by: group_by, order_by: Metrics::OrderBy::TransactionsReceived.identifier)
      expect(presenter.order_by).to eq(Metrics::OrderBy::TransactionsReceived.identifier)
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
      allow(client).to receive(:metrics) { instance_double(GovernmentServiceDataAPI::Metrics, totals: totals, metric_groups: [metric_group_one, metric_group_two]) }

      metric_group_presenter_one = instance_double(MetricGroupPresenter)
      metric_group_presenter_two = instance_double(MetricGroupPresenter)
      expect(MetricGroupPresenter).to receive(:new).with(metric_group_one, collapsed: false) { metric_group_presenter_one }
      expect(MetricGroupPresenter).to receive(:new).with(metric_group_two, collapsed: false) { metric_group_presenter_two }

      sorter = ->(_) {}
      allow(Metrics::OrderBy).to receive(:fetch) { sorter }

      expect(presenter.metric_groups).to match_array([totals_metric_presenter, metric_group_presenter_one, metric_group_presenter_two])
    end

    it "sets the metric group to be collapsed if it isn't ordered by name" do
      metric_group = instance_double(GovernmentServiceDataAPI::MetricGroup)
      allow(client).to receive(:metrics) { instance_double(GovernmentServiceDataAPI::Metrics, totals: totals, metric_groups: [metric_group]) }

      expect(MetricGroupPresenter).to receive(:new).with(metric_group, collapsed: true) { instance_double(MetricGroupPresenter) }

      allow(Metrics::OrderBy).to receive(:fetch) { ->(_) {} }
      presenter = described_class.new(entity, client: client, group_by: group_by, order_by: 'alternative metric')
      presenter.metric_groups
    end

    describe 'sorting' do
      let(:metric_groups) { 4.times.map { instance_double(GovernmentServiceDataAPI::MetricGroup) } }
      let(:metric_group_presenters) { 4.times.map { instance_double(MetricGroupPresenter) } }

      before do
        allow(client).to receive(:metrics) { instance_double(GovernmentServiceDataAPI::Metrics, totals: totals, metric_groups: metric_groups) }
        allow(MetricGroupPresenter).to receive(:new).and_return(*metric_group_presenters)

        # Setup an expected `sorted_order`, then stub a "sorter" which sorts according
        # to the index in this array. Afterwards we compare to this expected array, to
        # confirm that it's being sorted according to the proc returned by
        # `Metrics::OrderBy.fetch`.
        sorted_order = [metric_group_presenters[2], metric_group_presenters[3], metric_group_presenters[0], metric_group_presenters[1]]
        sorter = ->(metric_group_presenter) { sorted_order.index(metric_group_presenter) }
        allow(Metrics::OrderBy).to receive(:fetch) { sorter }
      end

      it 'sorts the metric groups, according to order by' do
        expect(presenter.metric_groups).to eq([totals_metric_presenter, metric_group_presenters[2], metric_group_presenters[3], metric_group_presenters[0], metric_group_presenters[1]])
      end

      it 'reverses the order, if order is ascending' do
        presenter = described_class.new(entity, client: client, group_by: group_by, order: Metrics::Order::Descending)
        expect(presenter.metric_groups).to eq([totals_metric_presenter, metric_group_presenters[2], metric_group_presenters[3], metric_group_presenters[0], metric_group_presenters[1]])
      end
    end

    describe 'totals metrics group presenter' do
      let(:metric_groups) { [instance_double(GovernmentServiceDataAPI::MetricGroup)] }
      let(:metric_group_presenter) { instance_double(MetricGroupPresenter) }

      before do
        allow(client).to receive(:metrics) { instance_double(GovernmentServiceDataAPI::Metrics, totals: totals, metric_groups: metric_groups) }
        allow(MetricGroupPresenter).to receive(:new).and_return(metric_group_presenter)

        allow(Metrics::OrderBy).to receive(:fetch) { ->(_) { 0 } }
      end

      it 'is prepended when ordered by name' do
        presenter = presenter(order_by: Metrics::OrderBy::Name.identifier, order: Metrics::Order::Ascending)
        expect(presenter.metric_groups).to eq([totals_metric_presenter, metric_group_presenter])

        presenter = presenter(order_by: Metrics::OrderBy::Name.identifier, order: Metrics::Order::Descending)
        expect(presenter.metric_groups).to eq([totals_metric_presenter, metric_group_presenter])
      end

      it 'is prepended when ordered by descending' do
        presenter = presenter(order_by: Metrics::OrderBy::TransactionsReceived.identifier, order: Metrics::Order::Descending)
        expect(presenter.metric_groups).to eq([totals_metric_presenter, metric_group_presenter])
      end

      it 'is appended when ordered by ascending' do
        presenter = presenter(order_by: Metrics::OrderBy::TransactionsReceived.identifier, order: Metrics::Order::Ascending)
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
