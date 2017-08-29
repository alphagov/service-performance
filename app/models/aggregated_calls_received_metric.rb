class AggregatedCallsReceivedMetric
  alias :read_attribute_for_serialization :send

  def initialize(organisation, time_period)
    @sampled = false
    @totals = CallsReceivedMetric
      .where(service_code: organisation.services.pluck(:natural_key))
      .where('starts_on >= ? AND ends_on <= ?', time_period.starts_on, time_period.ends_on)
      .each.with_object({}) do |metric, memo|
        if !metric.quantity.nil?
          memo[metric.item] ||= 0
          memo[metric.item] += metric.quantity
        end
        memo['sampled-total'] ||= 0
        memo['sampled-total'] += metric.sample_size || (metric.quantity || 0)
        @sampled |= metric.sampled
      end
  end

  def is_applicable?
    @totals.size.positive?
  end

  def total
    @totals['total']
  end

  def get_information
    @totals['get-information']
  end

  def chase_progress
    @totals['chase-progress']
  end

  def challenge_a_decision
    @totals['challenge-a-decision']
  end

  def other
    @totals['other']
  end

  def sampled_total
    @totals['sampled-total']
  end

  attr_reader :sampled
end
