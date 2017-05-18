require 'rails_helper'

RSpec.describe AggregatedTransactionsWithOutcomeMetric, type: :model do

  describe 'aggregates transactions with outcome metric' do
    specify 'for a given department' do
      department = FactoryGirl.create(:department)
      service1 = FactoryGirl.create(:service, department: department)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service1, starts_on: '2017-01-01', ends_on: '2017-01-31', quantity_with_any_outcome: 50, quantity_with_intended_outcome: 45)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service1, starts_on: '2017-02-01', ends_on: '2017-02-28', quantity_with_any_outcome: 60, quantity_with_intended_outcome: 55)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service1, starts_on: '2017-03-01', ends_on: '2017-03-31', quantity_with_any_outcome: 70, quantity_with_intended_outcome: 65)

      service2 = FactoryGirl.create(:service, department: department)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service2, starts_on: '2017-01-01', ends_on: '2017-01-31', quantity_with_any_outcome: 50, quantity_with_intended_outcome: 45)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service2, starts_on: '2017-02-01', ends_on: '2017-02-28', quantity_with_any_outcome: 60, quantity_with_intended_outcome: 55)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service2, starts_on: '2017-03-01', ends_on: '2017-03-31', quantity_with_any_outcome: 70, quantity_with_intended_outcome: 65)

      # ignores metrics with overlapping ranges
      FactoryGirl.create(:transactions_with_outcome_metric, service: service1, starts_on: '2016-12-01', ends_on: '2017-01-31', quantity_with_any_outcome: 30, quantity_with_intended_outcome: 25)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service2, starts_on: '2017-02-01', ends_on: '2017-04-30', quantity_with_any_outcome: 20, quantity_with_intended_outcome: 15)

      # ignores metrics for services, in other departments
      other_department = FactoryGirl.create(:department)
      other_service = FactoryGirl.create(:service, department: other_department)
      FactoryGirl.create(:transactions_with_outcome_metric, service: other_service, starts_on: '2017-01-01', ends_on: '2017-01-31', quantity_with_any_outcome: 10, quantity_with_intended_outcome: 5)

      time_period = instance_double(TimePeriod, starts_on: Date.parse('2017-01-01'), ends_on: Date.parse('2017-03-31'))
      metric = AggregatedTransactionsWithOutcomeMetric.new(department, time_period)
      expect(metric.total).to eq(360)
      expect(metric.with_intended_outcome).to eq(330)
    end

    specify 'for a given agency' do
      agency = FactoryGirl.create(:agency)
      service1 = FactoryGirl.create(:service, agency: agency)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service1, starts_on: '2017-01-01', ends_on: '2017-01-31', quantity_with_any_outcome: 50, quantity_with_intended_outcome: 45)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service1, starts_on: '2017-02-01', ends_on: '2017-02-28', quantity_with_any_outcome: 60, quantity_with_intended_outcome: 55)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service1, starts_on: '2017-03-01', ends_on: '2017-03-31', quantity_with_any_outcome: 70, quantity_with_intended_outcome: 65)

      service2 = FactoryGirl.create(:service, agency: agency)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service2, starts_on: '2017-01-01', ends_on: '2017-01-31', quantity_with_any_outcome: 50, quantity_with_intended_outcome: 45)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service2, starts_on: '2017-02-01', ends_on: '2017-02-28', quantity_with_any_outcome: 60, quantity_with_intended_outcome: 55)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service2, starts_on: '2017-03-01', ends_on: '2017-03-31', quantity_with_any_outcome: 70, quantity_with_intended_outcome: 65)

      # ignores metrics with overlapping ranges
      FactoryGirl.create(:transactions_with_outcome_metric, service: service1, starts_on: '2016-12-01', ends_on: '2017-01-31', quantity_with_any_outcome: 30, quantity_with_intended_outcome: 25)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service2, starts_on: '2017-02-01', ends_on: '2017-04-30', quantity_with_any_outcome: 20, quantity_with_intended_outcome: 15)

      # ignores metrics for services, in other departments
      other_agency = FactoryGirl.create(:agency)
      other_service = FactoryGirl.create(:service, agency: other_agency)
      FactoryGirl.create(:transactions_with_outcome_metric, service: other_service, starts_on: '2017-01-01', ends_on: '2017-01-31', quantity_with_any_outcome: 10, quantity_with_intended_outcome: 5)

      time_period = instance_double(TimePeriod, starts_on: Date.parse('2017-01-01'), ends_on: Date.parse('2017-03-31'))
      metric = AggregatedTransactionsWithOutcomeMetric.new(agency, time_period)
      expect(metric.total).to eq(360)
      expect(metric.with_intended_outcome).to eq(330)
    end

    specify 'for a given service' do
      service = FactoryGirl.create(:service)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service, starts_on: '2017-01-01', ends_on: '2017-01-31', quantity_with_any_outcome: 50, quantity_with_intended_outcome: 45)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service, starts_on: '2017-02-01', ends_on: '2017-02-28', quantity_with_any_outcome: 60, quantity_with_intended_outcome: 55)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service, starts_on: '2017-03-01', ends_on: '2017-03-31', quantity_with_any_outcome: 70, quantity_with_intended_outcome: 65)

      # ignores metrics with overlapping ranges
      FactoryGirl.create(:transactions_with_outcome_metric, service: service, starts_on: '2016-12-01', ends_on: '2017-01-31', quantity_with_any_outcome: 30, quantity_with_intended_outcome: 25)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service, starts_on: '2017-02-01', ends_on: '2017-04-30', quantity_with_any_outcome: 20, quantity_with_intended_outcome: 15)

      # ignores metrics for other services
      other_service = FactoryGirl.create(:service)
      FactoryGirl.create(:transactions_with_outcome_metric, service: other_service, starts_on: '2017-01-01', ends_on: '2017-01-31', quantity_with_any_outcome: 10, quantity_with_intended_outcome: 5)

      time_period = instance_double(TimePeriod, starts_on: Date.parse('2017-01-01'), ends_on: Date.parse('2017-03-31'))
      metric = AggregatedTransactionsWithOutcomeMetric.new(service, time_period)
      expect(metric.total).to eq(180)
      expect(metric.with_intended_outcome).to eq(165)
    end
  end

end
