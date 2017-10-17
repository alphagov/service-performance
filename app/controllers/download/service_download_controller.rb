class ServiceDownloadController < MetricsController
  def index
    service = Service.where(natural_key: params[:service_id]).first!
    raw = RawServiceMetrics.new(service, time_period: time_period)
    headers['Content-Disposition'] = "attachment; filename=\"#{filename(service)}.csv\""
    render body: raw.data.to_a.join(""), content_type: "text/csv"
  end

private

  def filename(service)
    "#{service.name}-service-performance".parameterize
  end
end
