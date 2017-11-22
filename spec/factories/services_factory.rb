FactoryGirl.define do
  factory :service do
    sequence(:natural_key) { |n| '%04d' % n }
    name 'Renew Service'

    delivery_organisation

    trait :transactions_received_not_applicable do
      online_transactions_applicable false
      phone_transactions_applicable false
      paper_transactions_applicable false
      face_to_face_transactions_applicable false
      other_transactions_applicable false
    end

    trait :calls_received_not_applicable do
      calls_received_applicable false
      calls_received_get_information_applicable false
      calls_received_chase_progress_applicable false
      calls_received_challenge_decision_applicable false
      calls_received_other_applicable false
      calls_received_perform_transaction_applicable false
    end
  end
end
