class AggregatedCallsReceivedMetric
  alias :read_attribute_for_serialization :send

  def initialize(organisation, time_period)
    @sampled = false
    @channels = CallsReceivedMetric
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

  def applicable?
    @channels.any?
  end

  def total
    @channels['total']
  end

  def get_information
    @channels['get-information']
  end

  def chase_progress
    @channels['chase-progress']
  end

  def challenge_a_decision
    @channels['challenge-a-decision']
  end

  def other
    @channels['other']
  end

  def sampled_total
    @channels['sampled-total']
  end

  attr_reader :sampled
end
