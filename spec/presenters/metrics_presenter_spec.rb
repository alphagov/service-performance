require 'rails_helper'

RSpec.describe MetricsPresenter do
  let(:entity) { double(:entity) }
  let(:client) { instance_double(CrossGovernmentServiceDataAPI::Client) }
  let(:group_by) { Metrics::Group::Department }
  let(:order) { nil }
  let(:order_by) { nil }
  let(:presenter) { described_class.new(entity, client: client, group_by: group_by, order: order, order_by: order_by) }

  describe '#initialize' do
    it 'defaults to Ascending order, when none provided' do
      presenter = described_class.new(entity, client: client, group_by: group_by)
      expect(presenter.order).to eq(Metrics::Order::Ascending)

      presenter = described_class.new(entity, client: client, group_by: group_by, order: nil)
      expect(presenter.order).to eq(Metrics::Order::Ascending)
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
    it 'fetches the metric groups with the `group_by` parameter' do
      expect(client).to receive(:metric_groups).with(entity, group_by: group_by) { [] }
      presenter.metric_groups
    end

    it 'wraps each metric group in a MetricGroupPresenter' do
      metric_group_1 = instance_double(CrossGovernmentServiceDataAPI::MetricGroup)
      metric_group_2 = instance_double(CrossGovernmentServiceDataAPI::MetricGroup)
      allow(client).to receive(:metric_groups) { [metric_group_1, metric_group_2] }

      metric_group_presenter_1 = instance_double(MetricGroupPresenter)
      metric_group_presenter_2 = instance_double(MetricGroupPresenter)
      expect(MetricGroupPresenter).to receive(:new).with(metric_group_1) { metric_group_presenter_1 }
      expect(MetricGroupPresenter).to receive(:new).with(metric_group_2) { metric_group_presenter_2 }

      sorter = ->(_) {}
      allow(Metrics::OrderBy).to receive(:fetch) { sorter }

      expect(presenter.metric_groups).to match_array([metric_group_presenter_1, metric_group_presenter_2])
    end

    describe 'sorting' do
      let(:metric_groups) { 4.times.map { instance_double(CrossGovernmentServiceDataAPI::MetricGroup) } }
      let(:metric_group_presenters) { 4.times.map { instance_double(MetricGroupPresenter) } }

      before do
        allow(client).to receive(:metric_groups) { metric_groups }
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
        expect(presenter.metric_groups).to eq([metric_group_presenters[2], metric_group_presenters[3], metric_group_presenters[0], metric_group_presenters[1]])
      end

      it 'revereses the order, if order is descending' do
        presenter = described_class.new(entity, client: client, group_by: group_by, order: Metrics::Order::Descending)
        expect(presenter.metric_groups).to eq([metric_group_presenters[1], metric_group_presenters[0], metric_group_presenters[3], metric_group_presenters[2]])
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
