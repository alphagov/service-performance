class AddApplicableFieldsToService < ActiveRecord::Migration[5.1]
  def change
    add_column :services, :online_transactions_applicable, :boolean, default: true
    add_column :services, :phone_transactions_applicable, :boolean, default: true
    add_column :services, :paper_transactions_applicable, :boolean, default: true
    add_column :services, :face_to_face_transactions_applicable, :boolean, default: true
    add_column :services, :other_transactions_applicable, :boolean, default: true
    add_column :services, :transactions_with_outcome_applicable, :boolean, default: true
    add_column :services, :transactions_with_intended_outcome_applicable, :boolean, default: true
    add_column :services, :calls_received_applicable, :boolean, default: true
    add_column :services, :calls_received_get_information_applicable, :boolean, default: true
    add_column :services, :calls_received_chase_progress_applicable, :boolean, default: true
    add_column :services, :calls_received_challenge_decision_applicable, :boolean, default: true
    add_column :services, :calls_received_other_applicable, :boolean, default: true
    add_column :services, :calls_received_perform_transaction_applicable, :boolean, default: true
  end
end