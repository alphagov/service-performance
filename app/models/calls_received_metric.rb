class CallsReceivedMetric < Metric
  define do
    item :total, from: ->(metrics) { metrics.calls_received }, applicable: ->(metrics) { metrics.service.calls_received_applicable? }
    item :get_information, from: ->(metrics) { metrics.calls_received_get_information }, applicable: ->(metrics) { metrics.service.calls_received_get_information_applicable? }
    item :chase_progress, from: ->(metrics) { metrics.calls_received_chase_progress }, applicable: ->(metrics) { metrics.service.calls_received_chase_progress_applicable? }
    item :challenge_a_decision, from: ->(metrics) { metrics.calls_received_challenge_decision }, applicable: ->(metrics) { metrics.service.calls_received_challenge_decision_applicable? }
    item :perform_transaction, from: ->(metrics) { metrics.calls_received_perform_transaction }, applicable: ->(metrics) { metrics.service.calls_received_perform_transaction_applicable? }
    item :other, from: ->(metrics) { metrics.calls_received_other }, applicable: ->(metrics) { metrics.service.calls_received_other_applicable? }
  end

  def sampled
    false
  end

  def sampled_total
    total
  end

  # TODO: implement this
  def perform_transaction_percentage; Float::NAN; end
  def get_information_percentage; Float::NAN; end
  def chase_progress_percentage; Float::NAN; end
  def challenge_a_decision_percentage; Float::NAN; end
  def other_percentage; Float::NAN; end

  def unspecified; 0; end
  def unspecified_percentage; Float::NAN; end
end
