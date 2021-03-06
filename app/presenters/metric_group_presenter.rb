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

    def service
      nil
    end

    def entity
      @entity.extend(EntityToPartialPath)
    end

    def totals?
      true
    end
  end

  def initialize(metric_group, collapsed: false, sort_value: nil)
    @metric_group = metric_group
    @entity = metric_group.entity
    @collapsed = collapsed
    @sort_value = sort_value
    @service = nil
    if @entity.class == Service
      @service = @entity
    end
  end

  def entity
    @entity.extend(EntityToPartialPath)
  end

  delegate :name, to: :entity

  attr_reader :sort_value, :service

  def metrics
    @metrics ||= [transactions_received_metric, calls_received_metric, transactions_processed_metric].each { |metric| metric.extend(MetricToPartialPath) }
  end

  def completeness
    completeness = metrics.flat_map { |metric| metric.completeness.values }.reduce(:+)

    percentage = (completeness.actual.to_f / completeness.expected.to_f) * 100
    percentage = 0 if percentage.nan?

    helper.number_to_percentage(percentage, precision: 0)
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

  def has_sort_value?
    !@sort_value.in? %i[not_provided not_applicable]
  end

  def collapsed?
    @collapsed ? true : false
  end

  def totals?
    false
  end

private

  delegate :sorted_metrics_by_month, :transactions_received_metric, :transactions_processed_metric, :calls_received_metric, to: :@metric_group

  def helper
    h = @helper ||= Class.new do
      include ActionView::Helpers::NumberHelper
    end
    h.new
  end
end
