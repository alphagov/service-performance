FactoryGirl.define do
  factory :calls_received_metric do
    department
    service

    starts_on { Date.today.beginning_of_month }
    ends_on { Date.today.end_of_month + 1.day }

    quantity 948
    sampled false
  end
end
