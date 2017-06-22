class ServiceMetricsController < MetricsController
  def index
    service = Service.where(natural_key: params[:service_id]).first!
    metrics = ServiceMetrics.new(service, group: group, time_period: time_period)
    render json: metrics
  end
end
