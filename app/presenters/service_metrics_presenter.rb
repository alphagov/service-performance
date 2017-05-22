class ServiceMetricsPresenter
  alias :read_attribute_for_serialization :send

  def initialize(department, service, time_period)
    @department = department
    @service = service
    @time_period = time_period
  end

  attr_reader :department, :service, :time_period

  def metrics
    [
      AggregatedTransactionsReceivedMetric.new(service, time_period),
      AggregatedTransactionsWithOutcomeMetric.new(service, time_period)
    ]
  end

  def serializer_class
    ServiceMetricsSerializer
  end
end
