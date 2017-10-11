require 'rails_helper'

RSpec.describe RawDeliveryOrganisationMetrics, type: :model do
  describe '#raw_delivery_organisation_metrics' do
    it 'we can get a CSV from a service' do
      department = FactoryGirl.create(:department)
      delivery_organisation = FactoryGirl.create(:delivery_organisation)

      service1 = FactoryGirl.create(:service, department: department, delivery_organisation: delivery_organisation)
      FactoryGirl.create(:transactions_received_metric, service: service1, starts_on: '2017-01-01', ends_on: '2017-01-31', channel: 'online', quantity: 100)
      FactoryGirl.create(:transactions_received_metric, service: service1, starts_on: '2017-02-01', ends_on: '2017-02-28', channel: 'online', quantity: 200)

      service2 = FactoryGirl.create(:service, department: department, delivery_organisation: delivery_organisation)
      FactoryGirl.create(:transactions_received_metric, service: service2, starts_on: '2017-03-01', ends_on: '2017-03-31', channel: 'online', quantity: 300)
      FactoryGirl.create(:transactions_received_metric, service: service2, starts_on: '2017-01-01', ends_on: '2017-03-31', channel: 'phone', quantity: 500)

      rows = RawDeliveryOrganisationMetrics.new(delivery_organisation, time_period: TimePeriod.default)
      expect(rows.data.to_a.join.split("\n").size).to eq(4)
    end
  end
end
