class AddUniqueIndexForServiceMonth < ActiveRecord::Migration[5.1]
  def up
    execute "CREATE UNIQUE INDEX unique_monthly_service_metrics ON monthly_service_metrics (service_id, DATE_TRUNC('month', month::timestamp without time zone))"
  end

  def down
    execute 'DROP INDEX unique_monthly_service_metrics'
  end
end
