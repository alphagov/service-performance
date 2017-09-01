class AggregatedTransactionsWithOutcomeMetric
  alias :read_attribute_for_serialization :send

  def initialize(organisation, time_period)
    @organisation = organisation
    @time_period = time_period

    defaults = Hash.new(Metric::NOT_APPLICABLE)
    @totals = metrics.group_by(&:outcome).each.with_object(defaults) do |(outcome, metrics), memo|
      quantity = begin
        if metrics.any?(&:quantity)
          metrics.sum { |metric| metric.quantity || 0 }
        else
          Metric::NOT_PROVIDED
        end
      end

      memo[outcome] = quantity
    end
  end

  def total
    @totals['any']
  end

  def with_intended_outcome
    @totals['intended']
  end

private

  attr_reader :organisation, :time_period

  def metrics
    TransactionsWithOutcomeMetric
      .where(service_code: organisation.services.pluck(:natural_key))
      .where('starts_on >= ? AND ends_on <= ?', time_period.starts_on, time_period.ends_on)
  end
end
