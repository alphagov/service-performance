require 'rails_helper'

RSpec.describe MonthlyServiceMetrics, type: :model do
  describe '.between' do
    it 'returns the metrics between the start and end months, inclusive' do
      service = FactoryGirl.create(:service)
      metrics1 = FactoryGirl.create(:monthly_service_metrics, service: service, month: YearMonth.new(2017, 4))
      metrics2 = FactoryGirl.create(:monthly_service_metrics, service: service, month: YearMonth.new(2017, 5))
      metrics3 = FactoryGirl.create(:monthly_service_metrics, service: service, month: YearMonth.new(2017, 6))
      metrics4 = FactoryGirl.create(:monthly_service_metrics, service: service, month: YearMonth.new(2017, 7))

      may = YearMonth.new(2017, 5)
      june = YearMonth.new(2017, 6)
      expect(MonthlyServiceMetrics.between(may, june)).to match_array([metrics2, metrics3])
    end
  end

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
