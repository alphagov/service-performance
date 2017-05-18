require 'rails_helper'

RSpec.describe ServiceMetricsPresenter, type: :presenter do
  let(:service) { instance_double(Service) }
  let(:time_period) { instance_double(TimePeriod) }
  subject(:service_metrics) { ServiceMetricsPresenter.new(service, time_period) }

  describe '#metrics' do
    before do
      allow(AggregatedTransactionsReceivedMetric).to receive(:new)
      allow(AggregatedTransactionsWithOutcomeMetric).to receive(:new)
    end

    it 'returns an aggregated transactions received metric' do
      aggregated_transactions_received_metric = instance_double(AggregatedTransactionsReceivedMetric)
      allow(AggregatedTransactionsReceivedMetric).to receive(:new).with(service, time_period) { aggregated_transactions_received_metric }

      expect(service_metrics.metrics).to include(aggregated_transactions_received_metric)
    end

    it 'returns an aggregated transactions with outcome metric' do
      aggregated_transactions_with_outcome_metric = instance_double(AggregatedTransactionsWithOutcomeMetric)
      allow(AggregatedTransactionsWithOutcomeMetric).to receive(:new).with(service, time_period) { aggregated_transactions_with_outcome_metric }

      expect(service_metrics.metrics).to include(aggregated_transactions_with_outcome_metric)
    end
  end

  describe '#serializer_class' do
    it 'is ServiceMetricsSerializer' do
      expect(service_metrics.serializer_class).to eq(ServiceMetricsSerializer)
    end
  end

end
