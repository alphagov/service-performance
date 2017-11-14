ActiveAdmin.register Service do
  includes :department, :delivery_organisation

  index do
    column :name
    column :delivery_organisation
    column :department
    actions
  end

  permit_params :id, :natural_key, :name, :hostname,
                :created_at, :updated_at, :delivery_organisation_code,
                :purpose, :how_it_works, :typical_users, :frequency_used,
                :duration_until_outcome, :start_page_url, :paper_form_url,
                :publish_token, :online_transactions_applicable,
                :phone_transactions_applicable, :paper_transactions_applicable,
                :face_to_face_transactions_applicable, :other_transactions_applicable,
                :transactions_with_outcome_applicable, :transactions_with_intended_outcome_applicable,
                :calls_received_applicable, :calls_received_get_information_applicable,
                :calls_received_chase_progress_applicable, :calls_received_challenge_decision_applicable,
                :calls_received_other_applicable, :calls_received_perform_transaction_applicable

  remove_filter :online_transactions_applicable, :phone_transactions_applicable,
                :paper_transactions_applicable,  :face_to_face_transactions_applicable,
                :other_transactions_applicable,  :transactions_with_outcome_applicable,
                :transactions_with_intended_outcome_applicable, :calls_received_applicable,
                :calls_received_get_information_applicable, :calls_received_chase_progress_applicable,
                :calls_received_challenge_decision_applicable, :calls_received_other_applicable,
                :calls_received_perform_transaction_applicable
end
