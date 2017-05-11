FactoryGirl.define do
  factory :calls_breakdown_metric do
    department
    service

    starts_on { Date.today.beginning_of_month }
    ends_on { Date.today.end_of_month + 1.day }

    quantity 837
    reason 'other'
    sampled false
  end
end
