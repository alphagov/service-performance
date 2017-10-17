class ServiceDownloadController < MetricsController
  def index
    service = Service.where(natural_key: params[:service_id]).first!
    raw = RawServiceMetrics.new(service, time_period: time_period)

    respond_to do |format|
      format.csv {
        headers['Content-Type'] = "text/csv; charset=utf-8"
        headers['Content-Disposition'] = "attachment; filename=\"#{filename(service)}.csv\""
        self.response_body = raw.data
      }
    end
  end

private

  def filename(service)
    "#{service.name}-service-performance".parameterize
  end
end
