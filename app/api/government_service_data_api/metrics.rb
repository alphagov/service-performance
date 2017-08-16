class GovernmentServiceDataAPI::Metrics
  def self.build(response, entity:)
    metrics = GovernmentServiceDataAPI::MetricGroup.new(entity, response['metrics'].index_by { |metric| metric['type'] })

    metric_groups = response['metric_groups'].map do |metric_group|
      GovernmentServiceDataAPI::MetricGroup.build(metric_group)
    end

    new(entity, metrics, metric_groups)
  end

  def initialize(entity, metrics, metric_groups)
    @entity = entity
    @metrics = metrics
    @metric_groups = metric_groups
  end

  attr_reader :entity, :metrics, :metric_groups
end
