class Metrics
  module GroupBy
    Government = :government
    Department = :department
    DeliveryOrganisation = :delivery_organisation
    Service = :service
  end

  class MetricGroup
    def initialize(entity, metrics)
      @entity, @metrics = entity, metrics
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

  def metric_groups
    entities.map do |entity|
      MetricGroup.new(entity, [
        AggregatedCallsReceivedMetric.new(entity, time_period),
        AggregatedTransactionsReceivedMetric.new(entity, time_period),
        AggregatedTransactionsWithOutcomeMetric.new(entity, time_period)
      ])
    end
  end

  private

  def entities
    raise NotImplementedError, "must be implemented by sub-classes"
  end
end
