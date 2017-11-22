class AddMetricsTimestamps < ActiveRecord::Migration[5.1]
  def up
    add_column :monthly_service_metrics, :created_at, :datetime, null: true
    add_column :monthly_service_metrics, :updated_at, :datetime, null: true

    MonthlyServiceMetrics.update_all created_at: Time.now, updated_at: Time.now

    change_column :monthly_service_metrics, :created_at, :datetime, null: false
    change_column :monthly_service_metrics, :updated_at, :datetime, null: false
  end

  def down
    remove_column :monthly_service_metrics, :created_at, :datetime, null: false
    remove_column :monthly_service_metrics, :updated_at, :datetime, null: false
  end
end
