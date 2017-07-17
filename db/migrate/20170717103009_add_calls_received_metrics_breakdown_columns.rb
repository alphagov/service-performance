class AddCallsReceivedMetricsBreakdownColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :calls_received_metrics, :quantity_of_get_information, :integer
    add_column :calls_received_metrics, :quantity_of_chase_progress, :integer
    add_column :calls_received_metrics, :quantity_of_challenge_a_decision, :integer
    add_column :calls_received_metrics, :quantity_of_other, :integer
  end
end
