require 'rails_helper'

RSpec.describe MissingDataCalculator, type: :model do
  describe "no data calculations" do
    subject(:department_test) { FactoryGirl.build(:department) }
    subject(:delivery_organistion_test) { FactoryGirl.build(:delivery_organistion, department: department_test) }

    it 'can calculate when no data available' do
      calc = MissingDataCalculator.new(department_test, TimePeriod.default)
      expect(calc.missing_data).to eq([])
    end
  end

  describe "missing data calculations" do
    it 'can calculate with published metrics' do
      department = FactoryGirl.build(:department)
      delivery_organisation = FactoryGirl.build(:delivery_organisation, department: department)
      service = FactoryGirl.build(:service, delivery_organisation: delivery_organisation, natural_key: 'a', name: 'test')
      metrics = FactoryGirl.build(:monthly_service_metrics,
          service: service,
          published: true,
          phone_transactions: 100,
          month: YearMonth.new(2018, 2))
      metrics.save

      calc = MissingDataCalculator.new(
        department,
        TimePeriod.new(Date.new(2018, 1, 1), Date.new(2018, 3, 1))
      )

      # We expect only 1 service to appear with missing data
      expect(calc.missing_data.length).to eq(1)
      # We expect there to be complains about all the metrics
      expect(calc.missing_data[0].metrics.length).to eq(13)
    end
  end
end
