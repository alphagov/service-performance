require 'rails_helper'

RSpec.describe RawDepartmentMetrics, type: :model do
  describe '#raw_delivery_organisation_metrics' do
    it 'we can get a CSV from a service' do
      department = FactoryGirl.create(:department)

      delivery_organisation1 = FactoryGirl.create(:delivery_organisation, department: department)
      delivery_organisation2 = FactoryGirl.create(:delivery_organisation, department: department)

      service1 = FactoryGirl.create(:service, department: department, delivery_organisation: delivery_organisation1)
      FactoryGirl.create(:transactions_received_metric, service: service1, starts_on: '2017-06-01', ends_on: '2017-06-30', channel: 'online', quantity: 100)
      FactoryGirl.create(:transactions_received_metric, service: service1, starts_on: '2017-07-01', ends_on: '2017-07-30', channel: 'online', quantity: 200)

      service2 = FactoryGirl.create(:service, department: department, delivery_organisation: delivery_organisation1)
      FactoryGirl.create(:transactions_received_metric, service: service2, starts_on: '2017-07-01', ends_on: '2017-07-30', channel: 'online', quantity: 300)
      FactoryGirl.create(:transactions_received_metric, service: service2, starts_on: '2017-08-01', ends_on: '2017-08-31', channel: 'phone', quantity: 500)

      service3 = FactoryGirl.create(:service, department: department, delivery_organisation: delivery_organisation2)
      FactoryGirl.create(:transactions_received_metric, service: service3, starts_on: '2017-07-01', ends_on: '2017-07-31', channel: 'online', quantity: 100)
      FactoryGirl.create(:transactions_received_metric, service: service3, starts_on: '2017-08-01', ends_on: '2017-08-28', channel: 'online', quantity: 200)


      rows = RawDepartmentMetrics.new(department, time_period: TimePeriod.default)
      expect(rows.data.to_a.join.split("\n").size).to eq(4)
    end
  end
end
