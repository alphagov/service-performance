InfluxDB::Rails.configure do |config|
  config.influxdb_database = "cgsd_development"
  config.influxdb_username = "root"
  config.influxdb_password = "root"
  config.influxdb_hosts    = ["localhost"]
  config.influxdb_port     = 8086

  # let's now disable collection of metrics about this Rails app
  config.ignored_environments << Rails.env
  config.instrumentation_enabled = false

  # config.series_name_for_controller_runtimes = "rails.controller"
  # config.series_name_for_view_runtimes       = "rails.view"
  # config.series_name_for_db_runtimes         = "rails.db"
end
