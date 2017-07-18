class AggregatedCallsReceivedMetric
  alias :read_attribute_for_serialization :send

  def initialize(organisation, time_period)
    @total = 0
    @get_information = 0
    @chase_progress = 0
    @challenge_a_decision = 0
    @other = 0
    @sampled = false
    @sampled_total = 0

    CallsReceivedMetric
      .where(service_code: organisation.services.pluck(:natural_key))
      .where('starts_on >= ? AND ends_on <= ?', time_period.starts_on, time_period.ends_on)
      .each do |metric, memo|
        @total += metric.quantity
        @get_information += metric.quantity_of_get_information || 0
        @chase_progress += metric.quantity_of_chase_progress || 0
        @challenge_a_decision += metric.quantity_of_challenge_a_decision || 0
        @other += metric.quantity_of_other || 0

        @sampled |= metric.sampled
        @sampled_total += metric.sample_size || metric.quantity
      end
  end

  attr_reader :total, :get_information, :chase_progress, :challenge_a_decision, :other,
              :sampled, :sampled_total
end
