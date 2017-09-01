class GovernmentServiceDataAPI::CallsReceivedMetric
  include GovernmentServiceDataAPI::MetricStatus

  def self.build(data)
    data ||= {}
    new(
      total: data.fetch('total', NOT_APPLICABLE),
      sampled: data.fetch('sampled', false),
      sampled_total: data.fetch('sampled_total', NOT_APPLICABLE),
      get_information: data.fetch('get_information', NOT_APPLICABLE),
      chase_progress: data.fetch('chase_progress', NOT_APPLICABLE),
      challenge_a_decision: data.fetch('challenge_a_decision', NOT_APPLICABLE),
      other: data.fetch('other', NOT_APPLICABLE),
    )
  end

  def initialize(total: nil, sampled: nil, sampled_total: nil, get_information: nil, chase_progress: nil, challenge_a_decision: nil, other: nil)
    @total = total || NOT_PROVIDED
    @sampled = sampled
    @sampled_total = sampled_total || NOT_PROVIDED
    @get_information = get_information || NOT_PROVIDED
    @chase_progress = chase_progress || NOT_PROVIDED
    @challenge_a_decision = challenge_a_decision || NOT_PROVIDED
    @other = other || NOT_PROVIDED
  end

  attr_reader :total, :sampled, :sampled_total, :get_information, :chase_progress,
              :challenge_a_decision, :other

  def not_applicable?
    [
      @total, @get_information,
      @chase_progress, @challenge_a_decision, @other,
    ].all? { |item| item == NOT_APPLICABLE }
  end

  def not_provided?
    [
      @total, @get_information,
      @chase_progress, @challenge_a_decision, @other,
    ].all? { |item| item == NOT_PROVIDED }
  end

  def get_information_percentage
    return @get_information if @get_information.in? [NOT_PROVIDED, NOT_APPLICABLE]
    (@get_information.to_f / sampled_total) * 100
  end

  def chase_progress_percentage
    return @chase_progress if @chase_progress.in? [NOT_PROVIDED, NOT_APPLICABLE]
    (@chase_progress.to_f / sampled_total) * 100
  end

  def challenge_a_decision_percentage
    return @challenge_a_decision if @challenge_a_decision.in? [NOT_PROVIDED, NOT_APPLICABLE]
    (@challenge_a_decision.to_f / sampled_total) * 100
  end

  def other_percentage
    return @other if @other.in? [NOT_PROVIDED, NOT_APPLICABLE]
    (@other.to_f / sampled_total) * 100
  end
end
