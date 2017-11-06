class CallsReceivedMetric
  alias :read_attribute_for_serialization :send

  def self.to_proc
    ->(metrics) { from_metrics(metrics) }
  end

  def self.from_metrics(metrics)
    service = metrics.service

    metric = ->(value, applicable:) do
      if value
        value
      else
        if applicable
          Metric::NOT_PROVIDED
        else
          Metric::NOT_APPLICABLE
        end
      end
    end

    new(
      total: metric.(metrics.calls_received, applicable: service.calls_received_applicable?),
      get_information: metric.(metrics.calls_received_get_information, applicable: service.calls_received_get_information_applicable?),
      chase_progress: metric.(metrics.calls_received_chase_progress, applicable: service.calls_received_chase_progress_applicable?),
      challenge_a_decision: metric.(metrics.calls_received_challenge_decision, applicable: service.calls_received_challenge_decision_applicable?),
      perform_transaction: metric.(metrics.calls_received_perform_transaction, applicable: service.calls_received_perform_transaction_applicable?),
      other: metric.(metrics.calls_received_other, applicable: service.calls_received_other_applicable?),
    )
  end

  def initialize(total:, get_information:, chase_progress:, challenge_a_decision:, perform_transaction:, other:)
    @total = total
    @get_information = get_information
    @chase_progress = chase_progress
    @challenge_a_decision = challenge_a_decision
    @perform_transaction = perform_transaction
    @other = other
  end

  attr_reader :total, :get_information, :chase_progress, :challenge_a_decision, :perform_transaction, :other

  def applicable?
    # TODO:
    # return false if !total || total.in?([Metric::NOT_APPLICABLE, Metric::NOT_PROVIDED])
    [total, get_information, chase_progress, challenge_a_decision, perform_transaction, other].any? { |value| value != Metric::NOT_APPLICABLE }
  end

  def sampled
    false
  end

  def sampled_total
    total
  end

  def completeness
    Completeness.new
  end

  def +(other)
    # TODO: test this
    sum = ->(a, b) do
      values = Set[a, b]
      case values
      when Set[Metric::NOT_APPLICABLE, Metric::NOT_APPLICABLE]
        Metric::NOT_APPLICABLE
      when Set[Metric::NOT_PROVIDED, Metric::NOT_PROVIDED]
        Metric::NOT_PROVIDED
      when Set[Metric::NOT_APPLICABLE, Metric::NOT_PROVIDED]
        Metric::NOT_PROVIDED
      else
        values.reject { |value| value.in?([Metric::NOT_APPLICABLE, Metric::NOT_PROVIDED]) }.reduce(:+)
      end
    end

    self.class.new(
      total: sum.(self.total, other.total),
      get_information: sum.(self.get_information, other.get_information),
      chase_progress: sum.(self.chase_progress, other.chase_progress),
      challenge_a_decision: sum.(self.challenge_a_decision, other.challenge_a_decision),
      perform_transaction: sum.(self.perform_transaction, other.perform_transaction),
      other: sum.(self.other, other.other),
    )
  end
end
