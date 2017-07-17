class DropCallsReceived < ActiveRecord::Migration[5.0]
  def change
    drop_table :calls_received_metrics
  end
end
