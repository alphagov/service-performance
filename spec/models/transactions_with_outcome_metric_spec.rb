require 'rails_helper'

RSpec.describe TransactionsWithOutcomeMetric, type: :model do
  let(:monthly_metrics) { FactoryGirl.build(:monthly_service_metrics, service: service) }
  subject(:metric) { TransactionsWithOutcomeMetric.new(monthly_metrics) }

  pending '#completeness'

  context 'with a service, not configured as "Not Applicable"' do
    let(:service) { FactoryGirl.build(:service, transactions_with_outcome_applicable: true, transactions_with_intended_outcome_applicable: true) }

    it 'returns a value if there is one' do
      monthly_metrics.transactions_with_outcome = 200
      monthly_metrics.transactions_with_intended_outcome = 150

      expect(metric.total).to eq(200)
      expect(metric.with_intended_outcome).to eq(150)
    end

    it 'returns not applicable, if no value is provided' do
      expect(metric.total).to eq(Metric::NOT_PROVIDED)
      expect(metric.with_intended_outcome).to eq(Metric::NOT_PROVIDED)
    end
  end


  context 'with a service, configured as "Not Applicable"' do
    let(:service) { FactoryGirl.build(:service, transactions_with_outcome_applicable: false, transactions_with_intended_outcome_applicable: false) }

    it 'returns a value if there is one' do
      monthly_metrics.transactions_with_outcome = 200
      monthly_metrics.transactions_with_intended_outcome = 150

      expect(metric.total).to eq(200)
      expect(metric.with_intended_outcome).to eq(150)
    end

    it 'returns not applicable, if no value is provided' do
      expect(metric.total).to eq(Metric::NOT_APPLICABLE)
      expect(metric.with_intended_outcome).to eq(Metric::NOT_APPLICABLE)
    end
  end


  describe '#applicable?' do
    context 'where one of the metric items has a value' do
      let(:service) { FactoryGirl.build(:service, transactions_with_outcome_applicable: true, transactions_with_intended_outcome_applicable: false) }

      it do
        monthly_metrics.transactions_with_outcome = 200

        expect(metric).to be_applicable
      end
    end

    context 'where one of the metric items is not provided' do
      let(:service) { FactoryGirl.build(:service, transactions_with_outcome_applicable: true, transactions_with_intended_outcome_applicable: false) }

      it do
        expect(metric).to be_applicable
      end
    end

    context 'where all of the metric items are not applicable' do
      let(:service) { FactoryGirl.build(:service, transactions_with_outcome_applicable: false, transactions_with_intended_outcome_applicable: false) }

      it do
        expect(metric).to_not be_applicable
      end
    end
  end
end
