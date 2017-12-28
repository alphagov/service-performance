class PreviewMetrics < Metrics
  def self.valid_group_bys
    [GroupBy::Service]
  end

  def initialize(monthly_service_metrics, time_period:)
    @monthly_service_metrics = monthly_service_metrics
    super(@monthly_service_metrics.service, group_by: nil, time_period: time_period)
  end

  def published_monthly_service_metrics(_ = nil)
    [@monthly_service_metrics]
  end

  def service
    @monthly_service_metrics.service
  end
end
