class RemoveReasonFromCallsReceived < ActiveRecord::Migration[5.0]
  def change
    remove_column :calls_received_metrics, :reason
  end
end
