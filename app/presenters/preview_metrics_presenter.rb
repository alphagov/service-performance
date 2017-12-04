class PreviewMetricsPresenter < MetricsPresenter
  def initialize(monthly_service_metrics)
    @monthly_service_metrics = monthly_service_metrics

    starts_on = monthly_service_metrics.month.starts_on
    ends_on = monthly_service_metrics.month.ends_on
    @time_period = TimePeriod.new(starts_on, ends_on)

    super(monthly_service_metrics.service, group_by: Metrics::GroupBy::Service, time_period: time_period)
  end

  attr_reader :monthly_service_metrics, :time_period

  def preview?
    true
  end

private

  def data
    @data ||= PreviewMetrics.new(monthly_service_metrics, time_period: time_period)
  end
end
