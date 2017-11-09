class Metrics
  module GroupBy
    GOVERNMENT = :government
    DEPARTMENT = :department
    DELIVERY_ORGANISATION = :delivery_organisation
    SERVICE = :service
  end

  class MetricGroup
    def initialize(entity, metrics)
      @entity = entity
      @metrics = metrics
    end

    alias :read_attribute_for_serialization :send

    attr_reader :entity, :metrics
  end

  def self.default_group_by
    self.valid_group_bys.first
  end

  def initialize(root, group_by: nil, time_period:)
    group_by ||= self.class.default_group_by
    raise ArgumentError, "unknown group_by: #{group_by}" unless self.class.valid_group_bys.include?(group_by)

    @root = root
    @group_by = group_by
    @time_period = time_period
  end

  alias :read_attribute_for_serialization :send
  attr_reader :group_by, :root, :time_period

  def metrics(entity: root)
    metrics = entity.metrics.joins(:service).between(time_period.start_month, time_period.end_month).published

    metrics = metrics.each.with_object({}) do |metric, memo|
      memo[metric.service] ||= time_period.months.each.with_object({}) do |month, months|
        months[month] = MonthlyServiceMetrics::Null.new(metric.service, month)
      end
      memo[metric.service][metric.month] = metric
    end

    values = metrics.each.with_object([]) do |(_service, months), memo|
      months.each do |_month, metric|
        memo << metric
      end
    end

    [
      values.map(&TransactionsReceivedMetric).reduce(:+),
      values.map(&TransactionsWithOutcomeMetric).reduce(:+),
      values.map(&CallsReceivedMetric).reduce(:+),
    ].compact.select(&:applicable?)
  end

  def metric_groups
    entities.map { |entity|
      m = metrics(entity: entity)
      MetricGroup.new(entity, m)
    }
  end

private

  def entities
    raise NotImplementedError, "must be implemented by sub-classes"
  end
end
