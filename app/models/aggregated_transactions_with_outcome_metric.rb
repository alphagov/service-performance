class AggregatedTransactionsWithOutcomeMetric
  alias :read_attribute_for_serialization :send

  def initialize(organisation, time_period)
    @items = TransactionsWithOutcomeMetric
      .where(service_code: organisation.services.pluck(:natural_key))
      .where('starts_on >= ? AND ends_on <= ?', time_period.starts_on, time_period.ends_on)
      .each.with_object(total: 0, with_intended_outcome: 0) do |metric, memo|
        memo[:total] += metric.quantity || 0 if metric.outcome == 'any'
        memo[:with_intended_outcome] += metric.quantity || 0 if metric.outcome == 'intended'
      end
  end

  def applicable?
    @items.any?
  end

  def total
    @items[:total]
  end

  def with_intended_outcome
    @items[:with_intended_outcome]
  end
end
