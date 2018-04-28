FactoryBot.define do
  factory :transactions_processed_metric do
    department
    service

    starts_on { Date.today.beginning_of_month }
    ends_on { Date.today.end_of_month + 1.day }

    outcome 'any'
    quantity 2830
    #quantity_with_intended_outcome 8393
  end
end
