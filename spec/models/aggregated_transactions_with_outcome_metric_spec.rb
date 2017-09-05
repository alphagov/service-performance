require 'rails_helper'

RSpec.describe AggregatedTransactionsWithOutcomeMetric, type: :model do
  describe 'aggregates transactions with outcome metric' do
    specify 'for a given department' do
      department = FactoryGirl.create(:department)
      service1 = FactoryGirl.create(:service, department: department)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service1, starts_on: '2017-01-01', ends_on: '2017-01-31', outcome: 'any', quantity: 50)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service1, starts_on: '2017-02-01', ends_on: '2017-02-28', outcome: 'any', quantity: 60)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service1, starts_on: '2017-03-01', ends_on: '2017-03-31', outcome: 'any', quantity: 70)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service1, starts_on: '2017-01-01', ends_on: '2017-01-31', outcome: 'intended', quantity: 45)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service1, starts_on: '2017-02-01', ends_on: '2017-02-28', outcome: 'intended', quantity: 55)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service1, starts_on: '2017-03-01', ends_on: '2017-03-31', outcome: 'intended', quantity: 65)

      service2 = FactoryGirl.create(:service, department: department)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service2, starts_on: '2017-01-01', ends_on: '2017-01-31', outcome: 'any', quantity: 50)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service2, starts_on: '2017-02-01', ends_on: '2017-02-28', outcome: 'any', quantity: 60)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service2, starts_on: '2017-03-01', ends_on: '2017-03-31', outcome: 'any', quantity: 70)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service2, starts_on: '2017-01-01', ends_on: '2017-01-31', outcome: 'intended', quantity: 45)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service2, starts_on: '2017-02-01', ends_on: '2017-02-28', outcome: 'intended', quantity: 55)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service2, starts_on: '2017-03-01', ends_on: '2017-03-31', outcome: 'intended', quantity: 65)

      # ignores metrics with overlapping ranges
      FactoryGirl.create(:transactions_with_outcome_metric, service: service1, starts_on: '2016-12-01', ends_on: '2017-01-31', outcome: 'any', quantity: 30)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service2, starts_on: '2017-02-01', ends_on: '2017-04-30', outcome: 'any', quantity: 20)

      # ignores metrics for services, in other departments
      other_department = FactoryGirl.create(:department)
      other_service = FactoryGirl.create(:service, department: other_department)
      FactoryGirl.create(:transactions_with_outcome_metric, service: other_service, starts_on: '2017-01-01', ends_on: '2017-01-31', outcome: 'any', quantity: 10)

      time_period = instance_double(TimePeriod, starts_on: Date.parse('2017-01-01'), ends_on: Date.parse('2017-03-31'), months: 12)
      metric = AggregatedTransactionsWithOutcomeMetric.new(department, time_period)
      expect(metric.total).to eq(360)
      expect(metric.with_intended_outcome).to eq(330)
    end

    specify 'for a given delivery_organisation' do
      delivery_organisation = FactoryGirl.create(:delivery_organisation)
      service1 = FactoryGirl.create(:service, delivery_organisation: delivery_organisation)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service1, starts_on: '2017-01-01', ends_on: '2017-01-31', outcome: 'any', quantity: 50)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service1, starts_on: '2017-02-01', ends_on: '2017-02-28', outcome: 'any', quantity: 60)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service1, starts_on: '2017-03-01', ends_on: '2017-03-31', outcome: 'any', quantity: 70)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service1, starts_on: '2017-01-01', ends_on: '2017-01-31', outcome: 'intended', quantity: 45)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service1, starts_on: '2017-02-01', ends_on: '2017-02-28', outcome: 'intended', quantity: 55)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service1, starts_on: '2017-03-01', ends_on: '2017-03-31', outcome: 'intended', quantity: 65)

      service2 = FactoryGirl.create(:service, delivery_organisation: delivery_organisation)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service2, starts_on: '2017-01-01', ends_on: '2017-01-31', outcome: 'any', quantity: 50)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service2, starts_on: '2017-02-01', ends_on: '2017-02-28', outcome: 'any', quantity: 60)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service2, starts_on: '2017-03-01', ends_on: '2017-03-31', outcome: 'any', quantity: 70)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service2, starts_on: '2017-01-01', ends_on: '2017-01-31', outcome: 'intended', quantity: 45)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service2, starts_on: '2017-02-01', ends_on: '2017-02-28', outcome: 'intended', quantity: 55)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service2, starts_on: '2017-03-01', ends_on: '2017-03-31', outcome: 'intended', quantity: 65)

      # ignores metrics with overlapping ranges
      FactoryGirl.create(:transactions_with_outcome_metric, service: service1, starts_on: '2016-12-01', ends_on: '2017-01-31', outcome: 'any', quantity: 30)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service2, starts_on: '2017-02-01', ends_on: '2017-04-30', outcome: 'any', quantity: 20)

      # ignores metrics for services, in other departments
      other_delivery_organisation = FactoryGirl.create(:delivery_organisation)
      other_service = FactoryGirl.create(:service, delivery_organisation: other_delivery_organisation)
      FactoryGirl.create(:transactions_with_outcome_metric, service: other_service, starts_on: '2017-01-01', ends_on: '2017-01-31', outcome: 'any', quantity: 10)

      time_period = instance_double(TimePeriod, starts_on: Date.parse('2017-01-01'), ends_on: Date.parse('2017-03-31'), months: 12)
      metric = AggregatedTransactionsWithOutcomeMetric.new(delivery_organisation, time_period)
      expect(metric.total).to eq(360)
      expect(metric.with_intended_outcome).to eq(330)
    end

    specify 'for a given service' do
      service = FactoryGirl.create(:service)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service, starts_on: '2017-01-01', ends_on: '2017-01-31', outcome: 'any', quantity: 50)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service, starts_on: '2017-02-01', ends_on: '2017-02-28', outcome: 'any', quantity: 60)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service, starts_on: '2017-03-01', ends_on: '2017-03-31', outcome: 'any', quantity: 70)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service, starts_on: '2017-01-01', ends_on: '2017-01-31', outcome: 'intended', quantity: 45)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service, starts_on: '2017-02-01', ends_on: '2017-02-28', outcome: 'intended', quantity: 55)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service, starts_on: '2017-03-01', ends_on: '2017-03-31', outcome: 'intended', quantity: 65)

      # ignores metrics with overlapping ranges
      FactoryGirl.create(:transactions_with_outcome_metric, service: service, starts_on: '2016-12-01', ends_on: '2017-01-31', outcome: 'any', quantity: 30)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service, starts_on: '2017-02-01', ends_on: '2017-04-30', outcome: 'any', quantity: 20)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service, starts_on: '2016-12-01', ends_on: '2017-01-31', outcome: 'intended', quantity: 25)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service, starts_on: '2017-02-01', ends_on: '2017-04-30', outcome: 'intended', quantity: 15)

      # ignores metrics for other services
      other_service = FactoryGirl.create(:service)
      FactoryGirl.create(:transactions_with_outcome_metric, service: other_service, starts_on: '2017-01-01', ends_on: '2017-01-31', outcome: 'any', quantity: 10)

      time_period = instance_double(TimePeriod, starts_on: Date.parse('2017-01-01'), ends_on: Date.parse('2017-03-31'), months: 12)
      metric = AggregatedTransactionsWithOutcomeMetric.new(service, time_period)
      expect(metric.total).to eq(180)
      expect(metric.with_intended_outcome).to eq(165)
    end

    specify 'with not applicable fields' do
      service = FactoryGirl.create(:service)

      time_period = instance_double(TimePeriod, starts_on: Date.parse('2017-01-01'), ends_on: Date.parse('2017-03-31'))
      metric = AggregatedTransactionsWithOutcomeMetric.new(service, time_period)

      expect(metric.total).to eq(Metric::NOT_APPLICABLE)
      expect(metric.with_intended_outcome).to eq(Metric::NOT_APPLICABLE)
    end

    specify 'with not provided fields' do
      service = FactoryGirl.create(:service)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service, starts_on: '2017-01-01', ends_on: '2017-01-31', outcome: 'any', quantity: nil)
      FactoryGirl.create(:transactions_with_outcome_metric, service: service, starts_on: '2017-01-01', ends_on: '2017-01-31', outcome: 'intended', quantity: nil)

      time_period = instance_double(TimePeriod, starts_on: Date.parse('2017-01-01'), ends_on: Date.parse('2017-01-31'), months: 12)
      metric = AggregatedTransactionsWithOutcomeMetric.new(service, time_period)

      expect(metric.total).to eq(Metric::NOT_PROVIDED)
      expect(metric.with_intended_outcome).to eq(Metric::NOT_PROVIDED)
    end
  end
end
