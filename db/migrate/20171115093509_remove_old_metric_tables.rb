class RemoveOldMetricTables < ActiveRecord::Migration[5.1]
  def up
    drop_table :calls_received_metrics
    drop_table :transactions_received_metrics
    drop_table :transactions_with_outcome_metrics
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
