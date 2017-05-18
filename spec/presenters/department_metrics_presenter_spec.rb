require 'rails_helper'

RSpec.describe DepartmentMetricsPresenter, type: :presenter do
  let(:department) { instance_double(Department) }
  let(:time_period) { instance_double(TimePeriod) }
  subject(:department_metrics) { DepartmentMetricsPresenter.new(department, time_period) }

  describe '#metrics' do
    before do
      allow(AggregatedTransactionsReceivedMetric).to receive(:new)
      allow(AggregatedTransactionsWithOutcomeMetric).to receive(:new)
    end

    it 'returns an aggregated transactions received metric' do
      aggregated_transactions_received_metric = instance_double(AggregatedTransactionsReceivedMetric)
      allow(AggregatedTransactionsReceivedMetric).to receive(:new).with(department, time_period) { aggregated_transactions_received_metric }

      expect(department_metrics.metrics).to include(aggregated_transactions_received_metric)
    end

    it 'returns an aggregated transactions with outcome metric' do
      aggregated_transactions_with_outcome_metric = instance_double(AggregatedTransactionsWithOutcomeMetric)
      allow(AggregatedTransactionsWithOutcomeMetric).to receive(:new).with(department, time_period) { aggregated_transactions_with_outcome_metric }

      expect(department_metrics.metrics).to include(aggregated_transactions_with_outcome_metric)
    end
  end

  describe '#serializer_class' do
    it 'is DepartmentMetricsSerializer' do
      expect(department_metrics.serializer_class).to eq(DepartmentMetricsSerializer)
    end
  end

end
