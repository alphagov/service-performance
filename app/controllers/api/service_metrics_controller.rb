module Api
  class ServiceMetricsController < MetricsController
    def index
      service = Service.where(natural_key: params[:service_id]).first!
      metrics = ServiceMetrics.new(service, group_by: group_by, time_period: time_period)

      respond_to do |format|
        format.json { render json: metrics }
        format.csv { render csv: MetricsCSVExporter.new(metrics.published_monthly_service_metrics) }
      end
    end
  end
end
