require 'rails_helper'

RSpec.describe TransactionsReceivedMetric, type: :model do
  let(:monthly_metrics) { FactoryGirl.build(:monthly_service_metrics, service: service) }
  subject(:metric) { TransactionsReceivedMetric.from_metrics(monthly_metrics) }

  pending '#completeness'
  pending '#total'

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

  describe '#applicable?' do
    context 'where one of the metric items has a value' do
      let(:service) { FactoryGirl.build(:service, online_transactions_applicable: true, phone_transactions_applicable: false, paper_transactions_applicable: false, face_to_face_transactions_applicable: false, other_transactions_applicable: false) }

      it do
        monthly_metrics.online_transactions = 200

        expect(metric).to be_applicable
      end
    end

    context 'where one of the metric items is not provided' do
      let(:service) { FactoryGirl.build(:service, online_transactions_applicable: true, phone_transactions_applicable: false, paper_transactions_applicable: false, face_to_face_transactions_applicable: false, other_transactions_applicable: false) }

      it do
        expect(metric).to be_applicable
      end
    end

    context 'where all of the metric items are not applicable' do
      let(:service) { FactoryGirl.build(:service, online_transactions_applicable: false, phone_transactions_applicable: false, paper_transactions_applicable: false, face_to_face_transactions_applicable: false, other_transactions_applicable: false) }

      it do
        expect(metric).to_not be_applicable
      end
    end
  end

  describe 'addition' do
    it 'combines the results of two TransactionsReceivedMetrics' do
      month1 = FactoryGirl.build(:monthly_service_metrics, online_transactions: 100, phone_transactions: 200, paper_transactions: 300, face_to_face_transactions: 400, other_transactions: 500)
      month2 = FactoryGirl.build(:monthly_service_metrics, online_transactions:  50, phone_transactions:  50, paper_transactions:  50, face_to_face_transactions:  50, other_transactions:  50)

      metrics1 = TransactionsReceivedMetric.from_metrics(month1)
      metrics2 = TransactionsReceivedMetric.from_metrics(month2)

      result = metrics1 + metrics2

      expect(result.online).to eq(150)
      expect(result.phone).to eq(250)
      expect(result.paper).to eq(350)
      expect(result.face_to_face).to eq(450)
      expect(result.other).to eq(550)
    end
  end
end
