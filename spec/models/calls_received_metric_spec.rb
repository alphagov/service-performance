require 'rails_helper'

RSpec.describe CallsReceivedMetric, type: :model do
  let(:monthly_metrics) { FactoryGirl.build(:monthly_service_metrics, service: service) }
  subject(:metric) { CallsReceivedMetric.from_metrics(monthly_metrics) }

  pending '#completeness'
  pending '#sampled'
  pending '#sampled_total'

  context 'with a service, not configured as "Not Applicable"' do
    let(:service) { FactoryGirl.build(:service, calls_received_applicable: true, calls_received_get_information_applicable: true, calls_received_chase_progress_applicable: true, calls_received_challenge_decision_applicable: true, calls_received_other_applicable: true, calls_received_perform_transaction_applicable: true) }

    it 'returns a value if there is one' do
      monthly_metrics.calls_received = 100
      monthly_metrics.calls_received_get_information = 200
      monthly_metrics.calls_received_chase_progress = 300
      monthly_metrics.calls_received_challenge_decision = 400
      monthly_metrics.calls_received_perform_transaction = 500
      monthly_metrics.calls_received_other = 600

      expect(metric.total).to eq(100)
      expect(metric.get_information).to eq(200)
      expect(metric.chase_progress).to eq(300)
      expect(metric.challenge_a_decision).to eq(400)
      expect(metric.perform_transaction).to eq(500)
      expect(metric.other).to eq(600)
    end

    it 'returns not applicable, if no value is provided' do
      expect(metric.total).to eq(Metric::NOT_PROVIDED)
      expect(metric.get_information).to eq(Metric::NOT_PROVIDED)
      expect(metric.chase_progress).to eq(Metric::NOT_PROVIDED)
      expect(metric.challenge_a_decision).to eq(Metric::NOT_PROVIDED)
      expect(metric.perform_transaction).to eq(Metric::NOT_PROVIDED)
      expect(metric.other).to eq(Metric::NOT_PROVIDED)
    end
  end


  context 'with a service, configured as "Not Applicable"' do
    let(:service) { FactoryGirl.build(:service, calls_received_applicable: false, calls_received_get_information_applicable: false, calls_received_chase_progress_applicable: false, calls_received_challenge_decision_applicable: false, calls_received_other_applicable: false, calls_received_perform_transaction_applicable: false) }

    it 'returns a value if there is one' do
      monthly_metrics.calls_received = 100
      monthly_metrics.calls_received_get_information = 200
      monthly_metrics.calls_received_chase_progress = 300
      monthly_metrics.calls_received_challenge_decision = 400
      monthly_metrics.calls_received_perform_transaction = 500
      monthly_metrics.calls_received_other = 600

      expect(metric.total).to eq(100)
      expect(metric.get_information).to eq(200)
      expect(metric.chase_progress).to eq(300)
      expect(metric.challenge_a_decision).to eq(400)
      expect(metric.perform_transaction).to eq(500)
      expect(metric.other).to eq(600)
    end

    it 'returns not applicable, if no value is provided' do
      expect(metric.total).to eq(Metric::NOT_APPLICABLE)
      expect(metric.get_information).to eq(Metric::NOT_APPLICABLE)
      expect(metric.chase_progress).to eq(Metric::NOT_APPLICABLE)
      expect(metric.challenge_a_decision).to eq(Metric::NOT_APPLICABLE)
      expect(metric.perform_transaction).to eq(Metric::NOT_APPLICABLE)
      expect(metric.other).to eq(Metric::NOT_APPLICABLE)
    end
  end

  describe '#applicable?' do
    context 'where one of the metric items has a value' do
      let(:service) { FactoryGirl.build(:service, calls_received_applicable: false, calls_received_get_information_applicable: true, calls_received_chase_progress_applicable: false, calls_received_challenge_decision_applicable: false, calls_received_other_applicable: false, calls_received_perform_transaction_applicable: false) }

      it do
        monthly_metrics.calls_received_get_information = 200

        expect(metric).to be_applicable
      end
    end

    context 'where one of the metric items is not provided' do
      let(:service) { FactoryGirl.build(:service, calls_received_applicable: false, calls_received_get_information_applicable: true, calls_received_chase_progress_applicable: false, calls_received_challenge_decision_applicable: false, calls_received_other_applicable: false, calls_received_perform_transaction_applicable: false) }

      it do
        expect(metric).to be_applicable
      end
    end

    context 'where all of the metric items are not applicable' do
      let(:service) { FactoryGirl.build(:service, calls_received_applicable: false, calls_received_get_information_applicable: false, calls_received_chase_progress_applicable: false, calls_received_challenge_decision_applicable: false, calls_received_other_applicable: false, calls_received_perform_transaction_applicable: false) }

      it do
        expect(metric).to_not be_applicable
      end
    end
  end

  describe 'addition' do
    it 'combines the results of two TransactionsReceivedMetrics' do
      month1 = FactoryGirl.build(:monthly_service_metrics, calls_received: 600, calls_received_get_information: 500, calls_received_chase_progress: 400, calls_received_challenge_decision: 300, calls_received_other: 200, calls_received_perform_transaction: 100)
      month2 = FactoryGirl.build(:monthly_service_metrics, calls_received:  50, calls_received_get_information:  50, calls_received_chase_progress:  50, calls_received_challenge_decision:  50, calls_received_other:  50, calls_received_perform_transaction:  50)

      metrics1 = CallsReceivedMetric.from_metrics(month1)
      metrics2 = CallsReceivedMetric.from_metrics(month2)

      result = metrics1 + metrics2

      expect(result.total).to eq(650)
      expect(result.get_information).to eq(550)
      expect(result.chase_progress).to eq(450)
      expect(result.challenge_a_decision).to eq(350)
      expect(result.perform_transaction).to eq(150)
      expect(result.other).to eq(250)
    end
  end
end
