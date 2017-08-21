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

  class Totals < self
    module EntityToPartialPath
      def to_partial_path
        'metric_groups/header/total'
      end
    end

    def entity
      @entity ||= @metric_group.entity.extend(EntityToPartialPath)
    end

    def totals?
      true
    end
  end

  def initialize(metric_group, collapsed: false)
    @metric_group = metric_group
    @collapsed = collapsed
  end

  def entity
    @entity ||= @metric_group.entity.extend(EntityToPartialPath)
  end

  def metrics
    @metrics ||= @metric_group.metrics.each { |metric| metric.extend(MetricToPartialPath) }
  end

  delegate :name, to: :entity
  delegate :transactions_received, :transactions_with_outcome, :calls_received, to: :@metric_group

  def delivery_organisations_count
    if entity.respond_to?(:delivery_organisations_count)
      entity.delivery_organisations_count
    end
  end

  def services_count
    if entity.respond_to?(:services_count)
      entity.services_count
    end
  end

  def collapsed?
    @collapsed ? true : false
  end

  def totals?
    false
  end
end
