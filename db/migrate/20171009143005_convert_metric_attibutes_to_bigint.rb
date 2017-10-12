class ConvertMetricAttibutesToBigint < ActiveRecord::Migration[5.1]
  def up
    change_column :monthly_service_metrics, :online_transactions, :bigint
    change_column :monthly_service_metrics, :phone_transactions, :bigint
    change_column :monthly_service_metrics, :paper_transactions, :bigint
    change_column :monthly_service_metrics, :face_to_face_transactions, :bigint
    change_column :monthly_service_metrics, :other_transactions, :bigint
    change_column :monthly_service_metrics, :transactions_with_outcome, :bigint
    change_column :monthly_service_metrics, :transactions_with_intended_outcome, :bigint
    change_column :monthly_service_metrics, :calls_received, :bigint
    change_column :monthly_service_metrics, :calls_received_get_information, :bigint
    change_column :monthly_service_metrics, :calls_received_chase_progress, :bigint
    change_column :monthly_service_metrics, :calls_received_challenge_decision, :bigint
    change_column :monthly_service_metrics, :calls_received_other, :bigint
    change_column :monthly_service_metrics, :calls_received_perform_transaction, :bigint
  end

  def down
    change_column :monthly_service_metrics, :online_transactions, :integer
    change_column :monthly_service_metrics, :phone_transactions, :integer
    change_column :monthly_service_metrics, :paper_transactions, :integer
    change_column :monthly_service_metrics, :face_to_face_transactions, :integer
    change_column :monthly_service_metrics, :other_transactions, :integer
    change_column :monthly_service_metrics, :transactions_with_outcome, :integer
    change_column :monthly_service_metrics, :transactions_with_intended_outcome, :integer
    change_column :monthly_service_metrics, :calls_received, :integer
    change_column :monthly_service_metrics, :calls_received_get_information, :integer
    change_column :monthly_service_metrics, :calls_received_chase_progress, :integer
    change_column :monthly_service_metrics, :calls_received_challenge_decision, :integer
    change_column :monthly_service_metrics, :calls_received_other, :integer
    change_column :monthly_service_metrics, :calls_received_perform_transaction, :integer
  end
end
