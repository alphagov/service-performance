class RenameOutcomeField < ActiveRecord::Migration[5.1]
  def change
    rename_column :monthly_service_metrics, :transactions_processed_with_intended_outcome, :transactions_processed_accepted
    rename_column :services, :transactions_processed_with_intended_outcome_applicable, :transactions_processed_accepted_applicable

    add_column :monthly_service_metrics, :transactions_processed_rejected, :bigint
    add_column :services, :transactions_processed_rejected_applicable, :boolean, default: true
  end
end
