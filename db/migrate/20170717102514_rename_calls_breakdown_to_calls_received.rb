class RenameCallsBreakdownToCallsReceived < ActiveRecord::Migration[5.0]
  def change
    rename_table :calls_breakdown_metrics, :calls_received_metrics
  end
end
