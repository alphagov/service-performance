class GovernmentServiceDataAPI::Metrics
  def self.build(response, entity:)
    totals = GovernmentServiceDataAPI::MetricGroup.new(entity, response['metrics'].index_by { |metric| metric['type'] })

    metric_groups = response['metric_groups'].map do |metric_group|
      GovernmentServiceDataAPI::MetricGroup.build(metric_group)
    end

    new(entity, totals, metric_groups)
  end

  def initialize(entity, totals, metric_groups)
    @entity = entity
    @totals = totals
    @metric_groups = metric_groups
  end

  attr_reader :entity, :totals, :metric_groups
end
