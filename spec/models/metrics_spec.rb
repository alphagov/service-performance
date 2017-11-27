require 'rails_helper'

RSpec.describe Metrics, type: :model do
  class FakeMetricsSubclass < Metrics
    def self.valid_group_bys
      ['default']
    end
  end

  let(:root) { double(:root) }
  let(:month) { instance_double(YearMonth) }
  let(:time_period) { instance_double(TimePeriod, start_month: month, end_month: month, months: [month]) }

  subject(:metrics) { FakeMetricsSubclass.new(root, time_period: time_period) }

  describe '#metrics' do
    it 'returns aggregated metrics for the root object' do
      service = instance_double(Service)
      monthly_service_metrics = instance_double(MonthlyServiceMetrics, month: month, service: service)
      allow(root).to receive_message_chain(:metrics, :joins, :between, :published) { [monthly_service_metrics] }

      calls_received_metric = instance_double(CallsReceivedMetric)
      expect(CallsReceivedMetric).to receive(:from_metrics).with(monthly_service_metrics) { calls_received_metric }

      transactions_received_metric = instance_double(TransactionsReceivedMetric)
      expect(TransactionsReceivedMetric).to receive(:from_metrics).with(monthly_service_metrics) { transactions_received_metric }

      transactions_processed_metric = instance_double(TransactionsProcessedMetric)
      expect(TransactionsProcessedMetric).to receive(:from_metrics).with(monthly_service_metrics) { transactions_processed_metric }

      expect(metrics.metrics).to match_array([calls_received_metric, transactions_received_metric, transactions_processed_metric])
    end
  end
end
