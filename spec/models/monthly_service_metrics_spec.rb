require 'rails_helper'

RSpec.describe MonthlyServiceMetrics, type: :model do
  describe '#publish_date' do
    it "returns nil if there's no month" do
      metrics = FactoryGirl.build(:monthly_service_metrics, month: nil)
      expect(metrics.publish_date).to be_nil
    end

    it 'returns the first of the month, 2 months from the given month' do
      metrics = FactoryGirl.build(:monthly_service_metrics, month: YearMonth.new(2017, 11))
      expect(metrics.publish_date).to eq(Date.new(2018, 1, 1))
    end
  end

  describe '#next_metrics_due_date' do
    it "returns nil if there's no month" do
      metrics = FactoryGirl.build(:monthly_service_metrics, month: nil)
      expect(metrics.next_metrics_due_date).to be_nil
    end

    it 'returns the first of the month, 2 months from the given month' do
      metrics = FactoryGirl.build(:monthly_service_metrics, month: YearMonth.new(2017, 11))
      expect(metrics.next_metrics_due_date).to eq(Date.new(2017, 12, 1))
    end
  end
end
