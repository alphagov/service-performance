require 'rails_helper'

RSpec.describe Metrics, type: :model do
  class FakeMetricsSubclass < Metrics
    def self.valid_group_bys
      ['default']
    end
  end

  let(:root) { double(:root) }
  let(:time_period) { instance_double(TimePeriod) }

  subject(:metrics) { FakeMetricsSubclass.new(root, time_period: time_period) }

  describe '#metrics' do
    it 'returns aggregated metrics for the root object' do
      calls_received_metric = instance_double(AggregatedCallsReceivedMetric)
      expect(AggregatedCallsReceivedMetric).to receive(:new).with(root, time_period) { calls_received_metric }
      expect(calls_received_metric).to receive(:is_applicable?) { true }

      transactions_received_metric = instance_double(AggregatedTransactionsReceivedMetric)
      expect(AggregatedTransactionsReceivedMetric).to receive(:new).with(root, time_period) { transactions_received_metric }
      expect(transactions_received_metric).to receive(:is_applicable?) { true }

      transactions_with_outcome_metric = instance_double(AggregatedTransactionsWithOutcomeMetric)
      expect(AggregatedTransactionsWithOutcomeMetric).to receive(:new).with(root, time_period) { transactions_with_outcome_metric }
      expect(transactions_with_outcome_metric).to receive(:is_applicable?) { true }

      expect(metrics.metrics).to match_array([calls_received_metric, transactions_received_metric, transactions_with_outcome_metric])
    end
  end
end
