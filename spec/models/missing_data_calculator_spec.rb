require "rails_helper"

RSpec.describe MissingDataCalculator, type: :model do
  describe "no data calculations" do
    subject(:department_test) { FactoryGirl.build(:department) }
    subject(:delivery_organistion_test) { FactoryGirl.build(:delivery_organistion, department: department_test) }
    it "can calculate when no data available" do
      calc = MissingDataCalculator.new(department_test, TimePeriod.default)

      expect(calc.missing_data).to eq([])
    end
  end

  describe "missing data calculations" do
    subject(:department) { FactoryGirl.build(:department) }
    subject(:delivery_organisation) { FactoryGirl.build(:delivery_organisation, department: department) }
    subject(:service) { FactoryGirl.build(:service, delivery_organisation: delivery_organisation, natural_key: "a", name: "test") }

    it "can calculate with published metrics" do
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

    it "can format months_missing string for consecutive months missing data within the same year" do
      metrics = FactoryGirl.build(:monthly_service_metrics,
          service: service,
          published: true,
          online_transactions: 100,
          month: YearMonth.new(2017, 12))
      metrics.save

      calc = MissingDataCalculator.new(
        department,
        TimePeriod.new(Date.new(2017, 10, 1), Date.new(2018, 3, 1))
      )

      expect(calc.missing_data[0].metrics[0][:months_missing]).to eq("October to November 2017, January to February 2018")
    end

    it "can format months_missing string for consecutive months missing data across years" do
      metrics = FactoryGirl.build(:monthly_service_metrics,
            service: service,
            published: true,
            phone_transactions: 100,
            month: YearMonth.new(2018, 2))
      metrics.save

      calc = MissingDataCalculator.new(
        department,
        TimePeriod.new(Date.new(2017, 10, 1), Date.new(2018, 3, 1))
      )

      expect(calc.missing_data[0].metrics[1][:months_missing]).to eq("October 2017 to January 2018")
    end

    it "can format months_missing string where both consecutive month and individual month data is missing" do
      metrics = FactoryGirl.build(:monthly_service_metrics,
          service: service,
          published: true,
          paper_transactions: 100,
          month: YearMonth.new(2018, 1))
      metrics.save

      calc = MissingDataCalculator.new(
        department,
        TimePeriod.new(Date.new(2017, 10, 1), Date.new(2018, 3, 1))
      )

      expect(calc.missing_data[0].metrics[2][:months_missing]).to eq("October to December 2017, February 2018")
    end

    it "can format months_missing string when only non consecutive month data is missing" do
      metrics = FactoryGirl.build(:monthly_service_metrics,
          service: service,
          published: true,
          online_transactions: 100,
          month: YearMonth.new(2017, 10),)
      metrics.save

      metrics = FactoryGirl.build(:monthly_service_metrics,
          service: service,
          published: true,
          online_transactions: 100,
          month: YearMonth.new(2017, 12),)
      metrics.save

      calc = MissingDataCalculator.new(
        department,
        TimePeriod.new(Date.new(2017, 9, 1), Date.new(2017, 12, 1))
      )

      expect(calc.missing_data[0].metrics[0][:months_missing]).to eq("September 2017, November 2017")
    end
  end
end
