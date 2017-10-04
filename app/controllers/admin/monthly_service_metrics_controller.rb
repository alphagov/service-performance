module Admin
  class MonthlyServiceMetricsController < Admin::ApplicationController
    def index
      respond_to do |format|
        format.html { super }
        format.csv do
          metrics = MonthlyServiceMetrics.all
          exporter = MetricsCSVExporter.new(metrics)
          send_data(exporter.to_csv)
        end
      end
    end

    def resource_class
      MonthlyServiceMetrics
    end

    def dashboard_class
      MonthlyServiceMetricsDashboard
    end
  end
end
