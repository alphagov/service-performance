require 'rails_helper'

RSpec.describe AggregatedTransactionsWithOutcomeMetric, type: :model do

  it 'aggregates transactions with outcome metric for a given service' do
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
