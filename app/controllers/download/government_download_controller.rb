class GovernmentDownloadController < MetricsController
  def index
    raw = RawGovernmentMetrics.new(time_period: time_period)

    respond_to do |format|
      format.csv {
        headers['Content-Type'] = "text/csv; charset=utf-8"
        headers['Content-Disposition'] = "attachment; filename=\"government-service-performance.csv\""
        self.response_body = raw.data
      }
    end
  end
end
