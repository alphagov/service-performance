class MetricGroupPresenter
  module EntityToPartialPath
    def to_partial_path
      'metric_groups/header/' + self.class.name.demodulize.underscore
    end
  end

  module MetricToPartialPath
    def to_partial_path
      'metrics/' + self.class.name.demodulize.underscore
    end
  end

  def initialize(metric_group)
    @metric_group = metric_group
  end

  def entity
    @entity ||= @metric_group.entity.extend(EntityToPartialPath)
  end

  def metrics
    @metrics ||= @metric_group.metrics.each {|metric| metric.extend(MetricToPartialPath) }
  end

  delegate :name, to: :entity
  delegate :transactions_received, :transactions_with_outcome, to: :@metric_group

  def delivery_organisations_count
    if entity.respond_to?(:delivery_organisations_count)
      entity.delivery_organisations_count
    else
      nil
    end
  end

  def services_count
    if entity.respond_to?(:services_count)
      entity.services_count
    else
      nil
    end
  end
end
