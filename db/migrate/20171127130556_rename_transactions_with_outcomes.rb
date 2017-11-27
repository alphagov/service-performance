class RenameTransactionsWithOutcomes < ActiveRecord::Migration[5.1]
  def up
    rename_column :monthly_service_metrics, :transactions_with_outcome, :transactions_processed
    rename_column :monthly_service_metrics, :transactions_with_intended_outcome, :transactions_processed_with_intended_outcome

    rename_column :services, :transactions_with_outcome_applicable, :transactions_processed_applicable
    rename_column :services, :transactions_with_intended_outcome_applicable, :transactions_processed_with_intended_outcome_applicable
  end

  def down
    rename_column :monthly_service_metrics, :transactions_processed, :transactions_with_outcome
    rename_column :monthly_service_metrics, :transactions_processed_with_intended_outcome, :transactions_with_intended_outcome

    rename_column :services, :transactions_processed_applicable, :transactions_with_outcome_applicable
    rename_column :services, :transactions_processed_with_intended_outcome_applicable, :transactions_with_intended_outcome_applicable

  end
end
