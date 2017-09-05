class MetricGroupPresenter
  module EntityToPartialPath
    def to_partial_path
      'metric_groups/header/' + self.class.name.demodulize.underscore
    end
  end

  module MetricToPartialPath
    def to_partial_path
      if self.not_provided?
        'metrics/not_provided_' + self.class.name.demodulize.underscore
      elsif self.not_applicable?
        'metrics/not_applicable_' + self.class.name.demodulize.underscore
      else
        'metrics/' + self.class.name.demodulize.underscore
      end
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

  def completeness
    res = @metric_group.metrics.reduce([0, 0]) { |memo, hash|
      if hash.completeness && hash.completeness.size.positive?
        val = %w(actual expected).map { |k|
          hash.completeness.values.map { |m| m[k] }.reduce(:+)
        }

        [memo[0] + val[0], memo[1] + val[1]]
      else
        [memo[0], memo[1]]
      end
    }

    v = (res[0].to_f / res[1].to_f) * 100
    helper.number_to_percentage(v, precision: 0)
  end

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

  def helper
    h = @helper ||= Class.new do
      include ActionView::Helpers::NumberHelper
    end
    h.new
  end
end
