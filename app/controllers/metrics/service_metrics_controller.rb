class ServiceMetricsController < MetricsController
  def index
    service = Service.where(natural_key: params[:service_id]).first!
    metrics = ServiceMetrics.new(service, group_by: group_by, time_period: time_period)
    render json: metrics
  end
end
