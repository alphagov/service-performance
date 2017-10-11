class GovernmentDownloadController < MetricsController
  def index
    raw = RawGovernmentMetrics.new(time_period: time_period)
    render body: raw.data, content_type: "text/csv"
  end
end
