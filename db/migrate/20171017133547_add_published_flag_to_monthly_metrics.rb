class AddPublishedFlagToMonthlyMetrics < ActiveRecord::Migration[5.1]
  def change
    add_column :monthly_service_metrics, :published, :boolean, default: false
  end
end
