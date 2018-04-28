FactoryBot.define do
  factory :transactions_received_metric do
    department
    service

    starts_on { Date.today.beginning_of_month }
    ends_on { Date.today.end_of_month + 1.day }

    channel 'online'
    quantity 2134
  end
end
