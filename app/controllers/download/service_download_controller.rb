class ServiceDownloadController < MetricsController
  def index
    service = Service.where(natural_key: params[:service_id]).first!
    raw = RawServiceMetrics.new(service, time_period: time_period)
    render body: raw.data, content_type: "text/csv"
  end
end
