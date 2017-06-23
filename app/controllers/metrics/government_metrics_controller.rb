class GovernmentMetricsController < MetricsController
  def index
    government = Government.new
    metrics = GovernmentMetrics.new(government, group_by: group_by, time_period: time_period)
    render json: metrics
  end
end
