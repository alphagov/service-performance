FactoryGirl.define do
  factory :monthly_service_metrics do
    service

    trait :published do
      published true
    end
  end
end
