require 'rails_helper'

RSpec.describe CallsReceivedMetric, type: :model do
  describe "validations" do
    subject(:calls_received_metric) { FactoryGirl.build(:calls_received_metric) }

    it { should be_valid }

    it 'requires a start date' do
      calls_received_metric.starts_on = nil
      expect(calls_received_metric).to fail_strict_validations
    end

    it 'requires an end date' do
      calls_received_metric.ends_on = nil
      expect(calls_received_metric).to fail_strict_validations
    end

    it 'requires a quantity' do
      calls_received_metric.quantity = nil
      expect(calls_received_metric).to fail_strict_validations
    end

    it 'indicates whether it was sampled' do
      calls_received_metric.sampled = nil
      expect(calls_received_metric).to fail_strict_validations
    end

    it "references a valid department" do
      calls_received_metric.department = nil
      expect(calls_received_metric).to fail_strict_validations
    end

    it "references a service" do
      calls_received_metric.service = nil
      expect(calls_received_metric).to fail_strict_validations
    end
  end
end
