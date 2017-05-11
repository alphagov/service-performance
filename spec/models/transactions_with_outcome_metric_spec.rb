require 'rails_helper'

RSpec.describe TransactionsWithOutcomeMetric, type: :model do
  describe "validations" do
    subject(:transactions_with_outcome_metric) { FactoryGirl.build(:transactions_with_outcome_metric) }

    it { should be_valid }

    it 'requires a start date' do
      transactions_with_outcome_metric.starts_on = nil
      expect(transactions_with_outcome_metric).to fail_strict_validations
    end

    it 'requires an end date' do
      transactions_with_outcome_metric.ends_on = nil
      expect(transactions_with_outcome_metric).to fail_strict_validations
    end

    it 'requires quantity_with_any_outcome' do
      transactions_with_outcome_metric.quantity_with_any_outcome = nil
      expect(transactions_with_outcome_metric).to fail_strict_validations
    end

    it 'requires quantity_with_intended_outcome' do
      transactions_with_outcome_metric.quantity_with_intended_outcome = nil
      expect(transactions_with_outcome_metric).to fail_strict_validations
    end

    it "references a valid department" do
      transactions_with_outcome_metric.department = nil
      expect(transactions_with_outcome_metric).to fail_strict_validations
    end

    it "references a service" do
      transactions_with_outcome_metric.service = nil
      expect(transactions_with_outcome_metric).to fail_strict_validations
    end
  end
end
