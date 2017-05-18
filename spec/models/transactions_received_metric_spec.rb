require 'rails_helper'

RSpec.describe TransactionsReceivedMetric, type: :model do
  describe "validations" do
    subject(:transactions_received_metric) { FactoryGirl.build(:transactions_received_metric) }

    it { should be_valid }

    it 'requires a start date' do
      transactions_received_metric.starts_on = nil
      expect(transactions_received_metric).to fail_strict_validations
    end

    it 'requires an end date' do
      transactions_received_metric.ends_on = nil
      expect(transactions_received_metric).to fail_strict_validations
    end

    it 'requires a channel' do
      transactions_received_metric.channel = nil
      expect(transactions_received_metric).to fail_strict_validations
    end

    it 'requires a quantity' do
      transactions_received_metric.quantity = nil
      expect(transactions_received_metric).to fail_strict_validations
    end

    it "references a valid department" do
      transactions_received_metric.department = nil
      expect(transactions_received_metric).to fail_strict_validations
    end

    it "references a service" do
      transactions_received_metric.service = nil
      expect(transactions_received_metric).to fail_strict_validations
    end
  end
end
