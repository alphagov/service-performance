class Metrics
  module Group
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

  def self.default_group
    self.supported_groups.first
  end

  def initialize(root, group: nil, time_period:)
    group ||= self.class.default_group
    raise ArgumentError, "unknown group: #{group}" unless self.class.supported_groups.include?(group)

    @root = root
    @group = group
    @time_period = time_period
  end

  alias :read_attribute_for_serialization :send
  attr_reader :group, :root, :time_period

  def metric_groups
    entities.map do |entity|
      MetricGroup.new(entity, [
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
