class AddCallsReceivedPerformTransactionToMonthlyServiceMetrics < ActiveRecord::Migration[5.1]
  def change
    add_column :monthly_service_metrics, :calls_received_perform_transaction, :integer
  end
end
