require 'rails_helper'

RSpec.describe CallsBreakdownMetric, type: :model do
  describe "validations" do
    subject(:calls_breakdown_metric) { FactoryGirl.build(:calls_breakdown_metric) }

    it { should be_valid }

    it 'requires a start date' do
      calls_breakdown_metric.starts_on = nil
      expect(calls_breakdown_metric).to fail_strict_validations
    end

    it 'requires an end date' do
      calls_breakdown_metric.ends_on = nil
      expect(calls_breakdown_metric).to fail_strict_validations
    end

    it 'requires a quantity' do
      calls_breakdown_metric.quantity = nil
      expect(calls_breakdown_metric).to fail_strict_validations
    end

    it 'indicates whether it was sampled' do
      calls_breakdown_metric.sampled = nil
      expect(calls_breakdown_metric).to fail_strict_validations
    end

    it 'requires a reason' do
      calls_breakdown_metric.reason = nil
      expect(calls_breakdown_metric).to fail_strict_validations
    end

    it "references a valid department" do
      calls_breakdown_metric.department = nil
      expect(calls_breakdown_metric).to fail_strict_validations
    end

    it "references a service" do
      calls_breakdown_metric.service = nil
      expect(calls_breakdown_metric).to fail_strict_validations
    end
  end
end
