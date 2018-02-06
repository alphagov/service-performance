class CallsReceivedMetric < Metric
  define do
    item :total, from: ->(metrics) { metrics.calls_received }, applicable: ->(metrics) { metrics.service.calls_received_applicable? }
    item :get_information, from: ->(metrics) { metrics.calls_received_get_information }, applicable: ->(metrics) { metrics.service.calls_received_get_information_applicable? }
    item :chase_progress, from: ->(metrics) { metrics.calls_received_chase_progress }, applicable: ->(metrics) { metrics.service.calls_received_chase_progress_applicable? }
    item :challenge_a_decision, from: ->(metrics) { metrics.calls_received_challenge_decision }, applicable: ->(metrics) { metrics.service.calls_received_challenge_decision_applicable? }
    item :perform_transaction, from: ->(metrics) { metrics.calls_received_perform_transaction }, applicable: ->(metrics) { metrics.service.calls_received_perform_transaction_applicable? }
    item :other, from: ->(metrics) { metrics.calls_received_other }, applicable: ->(metrics) { metrics.service.calls_received_other_applicable? }

    percentage_of :total
  end

  def sampled_total
    total
  end

  def unspecified
    return NOT_APPLICABLE if total.in?([NOT_APPLICABLE, NOT_PROVIDED])

    subtotal = [get_information, chase_progress, challenge_a_decision, perform_transaction, other].reject { |value|
      value.in?([NOT_APPLICABLE, NOT_PROVIDED])
    }.sum

    difference = total - subtotal
    if difference.positive?
      difference
    else
      NOT_APPLICABLE
    end
  end

  def unspecified_percentage
    return NOT_APPLICABLE if unspecified == NOT_APPLICABLE

    (unspecified.to_f / send(self.class.definition.denominator_method)) * 100
  end
end
