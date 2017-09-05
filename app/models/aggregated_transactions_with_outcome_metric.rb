class AggregatedTransactionsWithOutcomeMetric
  alias :read_attribute_for_serialization :send

  def initialize(organisation, time_period)
    @organisation = organisation
    @time_period = time_period
    @completeness = {}

    expected_multiplier = Completeness.multiplier(@organisation)

    defaults = Hash.new(Metric::NOT_APPLICABLE)
    @items = metrics.group_by(&:outcome).each.with_object(defaults) do |(outcome, metrics), memo|
      quantity = begin
        if metrics.any?(&:quantity)
          metrics.sum { |metric| metric.quantity || 0 }
        else
          Metric::NOT_PROVIDED
        end
      end

      @completeness[outcome] = {
        actual: metrics.count { |m| !m.quantity.in?([Metric::NOT_PROVIDED, nil]) },
        expected: @time_period.months * expected_multiplier
      }

      memo[outcome] = quantity
    end
  end

  def applicable?
    @items.any?
  end

  def total
    @items['any']
  end

  def with_intended_outcome
    @items['intended']
  end

  attr_reader :completeness

private

  attr_reader :organisation, :time_period

  def metrics
    TransactionsWithOutcomeMetric
      .where(service_code: organisation.services.pluck(:natural_key))
      .where('starts_on >= ? AND ends_on <= ?', time_period.starts_on, time_period.ends_on)
  end
end
