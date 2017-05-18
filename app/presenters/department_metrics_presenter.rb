class DepartmentMetricsPresenter
  alias :read_attribute_for_serialization :send

  def initialize(department, time_period)
    @department = department
    @time_period = time_period
  end

  attr_reader :department, :time_period

  def metrics
    [
      AggregatedTransactionsReceivedMetric.new(department, time_period),
      AggregatedTransactionsWithOutcomeMetric.new(department, time_period)
    ]
  end

  def serializer_class
    DepartmentMetricsSerializer
  end
end
