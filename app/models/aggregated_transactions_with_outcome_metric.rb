class AggregatedTransactionsWithOutcomeMetric
  alias :read_attribute_for_serialization :send

  def initialize(organisation, time_period)
    @totals = TransactionsWithOutcomeMetric
      .where(service_code: organisation.services.pluck(:natural_key))
      .where('starts_on >= ? AND ends_on <= ?', time_period.starts_on, time_period.ends_on)
      .each.with_object(total: 0, with_intended_outcome: 0) do |metric, memo|
        memo[:total] += metric.quantity if metric.outcome == 'any'
        memo[:with_intended_outcome] += metric.quantity if metric.outcome == 'intended'
      end
  end

  def total
    @totals[:total]
  end

  def with_intended_outcome
    @totals[:with_intended_outcome]
  end
end
