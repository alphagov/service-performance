require 'rails_helper'

RSpec.describe TransactionsReceivedMetric, type: :model do
  let(:monthly_metrics) { FactoryGirl.build(:monthly_service_metrics, service: service) }
  subject(:metric) { TransactionsReceivedMetric.new(monthly_metrics) }

  context 'with a service, not configured as "Not Applicable"' do
    let(:service) { FactoryGirl.build(:service, online_transactions_applicable: true, phone_transactions_applicable: true, paper_transactions_applicable: true, face_to_face_transactions_applicable: true, other_transactions_applicable: true) }

    it 'returns a value if there is one' do
      monthly_metrics.online_transactions = 100
      monthly_metrics.phone_transactions = 200
      monthly_metrics.paper_transactions = 300
      monthly_metrics.face_to_face_transactions = 400
      monthly_metrics.other_transactions = 500

      expect(metric.online).to eq(100)
      expect(metric.phone).to eq(200)
      expect(metric.paper).to eq(300)
      expect(metric.face_to_face).to eq(400)
      expect(metric.other).to eq(500)
    end

    it 'returns not applicable, if no value is provided' do
      expect(metric.online).to eq(Metric::NOT_PROVIDED)
      expect(metric.phone).to eq(Metric::NOT_PROVIDED)
      expect(metric.paper).to eq(Metric::NOT_PROVIDED)
      expect(metric.face_to_face).to eq(Metric::NOT_PROVIDED)
      expect(metric.other).to eq(Metric::NOT_PROVIDED)
    end
  end


  context 'with a service, configured as "Not Applicable"' do
    let(:service) { FactoryGirl.build(:service, online_transactions_applicable: false, phone_transactions_applicable: false, paper_transactions_applicable: false, face_to_face_transactions_applicable: false, other_transactions_applicable: false) }

    it 'returns a value if there is one' do
      monthly_metrics.online_transactions = 100
      monthly_metrics.phone_transactions = 200
      monthly_metrics.paper_transactions = 300
      monthly_metrics.face_to_face_transactions = 400
      monthly_metrics.other_transactions = 500

      expect(metric.online).to eq(100)
      expect(metric.phone).to eq(200)
      expect(metric.paper).to eq(300)
      expect(metric.face_to_face).to eq(400)
      expect(metric.other).to eq(500)
    end

    it 'returns not applicable, if no value is provided' do
      expect(metric.online).to eq(Metric::NOT_APPLICABLE)
      expect(metric.phone).to eq(Metric::NOT_APPLICABLE)
      expect(metric.paper).to eq(Metric::NOT_APPLICABLE)
      expect(metric.face_to_face).to eq(Metric::NOT_APPLICABLE)
      expect(metric.other).to eq(Metric::NOT_APPLICABLE)
    end
  end
end
