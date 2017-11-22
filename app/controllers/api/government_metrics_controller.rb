module Api
  class GovernmentMetricsController < MetricsController
    def index
      government = Government.new
      metrics = GovernmentMetrics.new(government, group_by: group_by, time_period: time_period)

      respond_to do |format|
        format.json { render json: metrics }
        format.csv { render csv: MetricsCSVExporter.new(metrics.published_monthly_service_metrics) }
      end
    end
  end
end
