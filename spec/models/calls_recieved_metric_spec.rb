require 'rails_helper'

RSpec.describe CallsReceivedMetric, type: :model do
  let(:service) {
    instance_double(Service,
      calls_received_challenge_decision_applicable?: true,
      calls_received_perform_transaction_applicable?: false,
      calls_received_other_applicable?: true)
  }

  let(:metrics) {
    instance_double(MonthlyServiceMetrics,
      service: service,
      calls_received_challenge_decision: nil, # not provided
      calls_received_perform_transaction: nil, # not applicable
      calls_received_other: nil) # not provided
  }

  describe '#unspecified' do
    it 'returns the difference between the metric items & total' do
      allow(metrics).to receive_messages(
        calls_received: 1000,
        calls_received_get_information: 100,
        calls_received_chase_progress: 200,
      )

      metric = CallsReceivedMetric.from_metrics(metrics)
      expect(metric.unspecified).to eq(700)
    end

    it 'returns NOT_APPLICABLE if the subtotal equals the total' do
      allow(metrics).to receive_messages(
        calls_received: 1000,
        calls_received_get_information: 500,
        calls_received_chase_progress: 500,
      )

      metric = CallsReceivedMetric.from_metrics(metrics)
      expect(metric.unspecified).to eq(Metric::NOT_APPLICABLE)
    end

    it 'returns NOT_APPLICABLE if the subtotal is greater than the total' do
      allow(metrics).to receive_messages(
        calls_received: 1000,
        calls_received_get_information: 1000,
        calls_received_chase_progress: 2000,
      )

      metric = CallsReceivedMetric.from_metrics(metrics)
      expect(metric.unspecified).to eq(Metric::NOT_APPLICABLE)
    end
  end

  describe '#unspecified_percentage' do
    it 'returns the percentage of the total' do
      allow(metrics).to receive_messages(
        calls_received: 1000,
        calls_received_get_information: 250,
        calls_received_chase_progress: 250,
      )

      metric = CallsReceivedMetric.from_metrics(metrics)
      expect(metric.unspecified_percentage).to eq(50.0)
    end

    it 'returns NOT_APPLICABLE if the total is NOT_APPLICABLE' do
      allow(service).to receive(:calls_received_applicable?) { false }
      allow(metrics).to receive_messages(
        calls_received: nil,
        calls_received_get_information: 250,
        calls_received_chase_progress: 250,
      )

      metric = CallsReceivedMetric.from_metrics(metrics)
      expect(metric.total).to eq(Metric::NOT_APPLICABLE)
      expect(metric.unspecified_percentage).to eq(Metric::NOT_APPLICABLE)
    end

    it 'returns NOT_APPLICABLE if the total is NOT_PROVIDED' do
      allow(service).to receive(:calls_received_applicable?) { true }
      allow(metrics).to receive_messages(
        calls_received: nil,
        calls_received_get_information: 250,
        calls_received_chase_progress: 250,
      )

      metric = CallsReceivedMetric.from_metrics(metrics)
      expect(metric.total).to eq(Metric::NOT_PROVIDED)
      expect(metric.unspecified_percentage).to eq(Metric::NOT_APPLICABLE)
    end

    it 'returns NOT_APPLICABLE if unspecified is NOT_APPLICABLE' do
      allow(metrics).to receive_messages(
        calls_received: 1000,
        calls_received_get_information: 500,
        calls_received_chase_progress: 500,
      )

      metric = CallsReceivedMetric.from_metrics(metrics)
      expect(metric.unspecified_percentage).to eq(Metric::NOT_APPLICABLE)
    end
  end
end
