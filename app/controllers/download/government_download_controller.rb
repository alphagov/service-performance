class GovernmentDownloadController < MetricsController
  def index
    raw = RawGovernmentMetrics.new(time_period: time_period)
    headers['Content-Disposition'] = "attachment; filename=\"government-service-performance.csv\""
    render body: raw.data.to_a.join(""), content_type: "text/csv"
  end
end
