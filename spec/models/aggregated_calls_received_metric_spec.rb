require 'rails_helper'

RSpec.describe AggregatedCallsReceivedMetric, type: :model do

  describe 'aggregates calls received metric' do
    specify 'for a given department' do
      department = FactoryGirl.create(:department)
      service1 = FactoryGirl.create(:service, department: department)
      FactoryGirl.create(:calls_received_metric, service: service1, starts_on: '2017-01-01', ends_on: '2017-01-31', quantity: 50, quantity_of_get_information: 45)
      FactoryGirl.create(:calls_received_metric, service: service1, starts_on: '2017-02-01', ends_on: '2017-02-28', quantity: 60, quantity_of_get_information: 55)
      FactoryGirl.create(:calls_received_metric, service: service1, starts_on: '2017-03-01', ends_on: '2017-03-31', quantity: 70, quantity_of_get_information: 65)

      service2 = FactoryGirl.create(:service, department: department)
      FactoryGirl.create(:calls_received_metric, service: service2, starts_on: '2017-01-01', ends_on: '2017-01-31', quantity: 50, quantity_of_get_information: 45)
      FactoryGirl.create(:calls_received_metric, service: service2, starts_on: '2017-02-01', ends_on: '2017-02-28', quantity: 60, quantity_of_get_information: 55)
      FactoryGirl.create(:calls_received_metric, service: service2, starts_on: '2017-03-01', ends_on: '2017-03-31', quantity: 70, quantity_of_get_information: 65)

      # ignores metrics with overlapping ranges
      FactoryGirl.create(:calls_received_metric, service: service1, starts_on: '2016-12-01', ends_on: '2017-01-31', quantity: 30, quantity_of_get_information: 25)
      FactoryGirl.create(:calls_received_metric, service: service2, starts_on: '2017-02-01', ends_on: '2017-04-30', quantity: 20, quantity_of_get_information: 15)

      # ignores metrics for services, in other departments
      other_department = FactoryGirl.create(:department)
      other_service = FactoryGirl.create(:service, department: other_department)
      FactoryGirl.create(:calls_received_metric, service: other_service, starts_on: '2017-01-01', ends_on: '2017-01-31', quantity: 10, quantity_of_get_information: 5)

      time_period = instance_double(TimePeriod, starts_on: Date.parse('2017-01-01'), ends_on: Date.parse('2017-03-31'))
      metric = AggregatedCallsReceivedMetric.new(department, time_period)
      expect(metric.total).to eq(360)
      expect(metric.get_information).to eq(330)
      expect(metric.chase_progress).to eq(0)
      expect(metric.challenge_a_decision).to eq(0)
      expect(metric.other).to eq(0)
    end

    specify 'for a given delivery_organisation' do
      delivery_organisation = FactoryGirl.create(:delivery_organisation)
      service1 = FactoryGirl.create(:service, delivery_organisation: delivery_organisation)
      FactoryGirl.create(:calls_received_metric, service: service1, starts_on: '2017-01-01', ends_on: '2017-01-31', quantity: 50, quantity_of_get_information: 45)
      FactoryGirl.create(:calls_received_metric, service: service1, starts_on: '2017-02-01', ends_on: '2017-02-28', quantity: 60, quantity_of_get_information: 55)
      FactoryGirl.create(:calls_received_metric, service: service1, starts_on: '2017-03-01', ends_on: '2017-03-31', quantity: 70, quantity_of_get_information: 65)

      service2 = FactoryGirl.create(:service, delivery_organisation: delivery_organisation)
      FactoryGirl.create(:calls_received_metric, service: service2, starts_on: '2017-01-01', ends_on: '2017-01-31', quantity: 50, quantity_of_get_information: 45)
      FactoryGirl.create(:calls_received_metric, service: service2, starts_on: '2017-02-01', ends_on: '2017-02-28', quantity: 60, quantity_of_get_information: 55)
      FactoryGirl.create(:calls_received_metric, service: service2, starts_on: '2017-03-01', ends_on: '2017-03-31', quantity: 70, quantity_of_get_information: 65)

      # ignores metrics with overlapping ranges
      FactoryGirl.create(:calls_received_metric, service: service1, starts_on: '2016-12-01', ends_on: '2017-01-31', quantity: 30, quantity_of_get_information: 25)
      FactoryGirl.create(:calls_received_metric, service: service2, starts_on: '2017-02-01', ends_on: '2017-04-30', quantity: 20, quantity_of_get_information: 15)

      # ignores metrics for services, in other departments
      other_delivery_organisation = FactoryGirl.create(:delivery_organisation)
      other_service = FactoryGirl.create(:service, delivery_organisation: other_delivery_organisation)
      FactoryGirl.create(:calls_received_metric, service: other_service, starts_on: '2017-01-01', ends_on: '2017-01-31', quantity: 10, quantity_of_get_information: 5)

      time_period = instance_double(TimePeriod, starts_on: Date.parse('2017-01-01'), ends_on: Date.parse('2017-03-31'))
      metric = AggregatedCallsReceivedMetric.new(delivery_organisation, time_period)
      expect(metric.total).to eq(360)
      expect(metric.get_information).to eq(330)
      expect(metric.chase_progress).to eq(0)
      expect(metric.challenge_a_decision).to eq(0)
      expect(metric.other).to eq(0)
    end

    specify 'for a given service' do
      service = FactoryGirl.create(:service)
      FactoryGirl.create(:calls_received_metric, service: service, starts_on: '2017-01-01', ends_on: '2017-01-31', quantity: 50, quantity_of_get_information: 45)
      FactoryGirl.create(:calls_received_metric, service: service, starts_on: '2017-02-01', ends_on: '2017-02-28', quantity: 60, quantity_of_get_information: 55)
      FactoryGirl.create(:calls_received_metric, service: service, starts_on: '2017-03-01', ends_on: '2017-03-31', quantity: 70, quantity_of_get_information: 65)

      # ignores metrics with overlapping ranges
      FactoryGirl.create(:calls_received_metric, service: service, starts_on: '2016-12-01', ends_on: '2017-01-31', quantity: 30, quantity_of_get_information: 25)
      FactoryGirl.create(:calls_received_metric, service: service, starts_on: '2017-02-01', ends_on: '2017-04-30', quantity: 20, quantity_of_get_information: 15)

      # ignores metrics for other services
      other_service = FactoryGirl.create(:service)
      FactoryGirl.create(:calls_received_metric, service: other_service, starts_on: '2017-01-01', ends_on: '2017-01-31', quantity: 10, quantity_of_get_information: 5)

      time_period = instance_double(TimePeriod, starts_on: Date.parse('2017-01-01'), ends_on: Date.parse('2017-03-31'))
      metric = AggregatedCallsReceivedMetric.new(service, time_period)
      expect(metric.total).to eq(180)
      expect(metric.get_information).to eq(165)
      expect(metric.chase_progress).to eq(0)
      expect(metric.challenge_a_decision).to eq(0)
      expect(metric.other).to eq(0)
    end

    context 'aggregating sampled & non-sampled data' do
      it 'is sampled if any of the metrics are sampled' do
        service = FactoryGirl.create(:service)
        FactoryGirl.create(:calls_received_metric, service: service, starts_on: '2017-01-01', ends_on: '2017-01-31', quantity: 50, sampled: false)
        FactoryGirl.create(:calls_received_metric, service: service, starts_on: '2017-02-01', ends_on: '2017-02-28', quantity: 60, sampled: true, sample_size: 15)
        FactoryGirl.create(:calls_received_metric, service: service, starts_on: '2017-03-01', ends_on: '2017-03-31', quantity: 70, sampled: false)

        time_period = instance_double(TimePeriod, starts_on: Date.parse('2017-01-01'), ends_on: Date.parse('2017-03-31'))
        metric = AggregatedCallsReceivedMetric.new(service, time_period)
        expect(metric.total).to eq(180)
        expect(metric.sampled).to be_truthy
        expect(metric.sampled_total).to eq(135)
      end
      
      it "isn't sampled if none of the metrics are sampled" do
        service = FactoryGirl.create(:service)
        FactoryGirl.create(:calls_received_metric, service: service, starts_on: '2017-01-01', ends_on: '2017-01-31', quantity: 50, sampled: false)
        FactoryGirl.create(:calls_received_metric, service: service, starts_on: '2017-02-01', ends_on: '2017-02-28', quantity: 60, sampled: false)
        FactoryGirl.create(:calls_received_metric, service: service, starts_on: '2017-03-01', ends_on: '2017-03-31', quantity: 70, sampled: false)

        time_period = instance_double(TimePeriod, starts_on: Date.parse('2017-01-01'), ends_on: Date.parse('2017-03-31'))
        metric = AggregatedCallsReceivedMetric.new(service, time_period)
        expect(metric.total).to eq(180)
        expect(metric.sampled).to be_falsey
        expect(metric.sampled_total).to eq(180)
      end
    end
  end

end
