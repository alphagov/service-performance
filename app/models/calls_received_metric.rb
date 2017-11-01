class CallsReceivedMetric
  def initialize(metrics)
    @metrics = metrics
    @service = metrics.service
  end

  def total
    if metrics.calls_received
      metrics.calls_received
    else
      if service.calls_received_applicable?
        Metric::NOT_PROVIDED
      else
        Metric::NOT_APPLICABLE
      end
    end
  end

  def get_information
    if metrics.calls_received_get_information
      metrics.calls_received_get_information
    else
      if service.calls_received_get_information_applicable?
        Metric::NOT_PROVIDED
      else
        Metric::NOT_APPLICABLE
      end
    end
  end

  def chase_progress
    if metrics.calls_received_chase_progress
      metrics.calls_received_chase_progress
    else
      if service.calls_received_chase_progress_applicable?
        Metric::NOT_PROVIDED
      else
        Metric::NOT_APPLICABLE
      end
    end
  end

  def challenge_a_decision
    if metrics.calls_received_challenge_decision
      metrics.calls_received_challenge_decision
    else
      if service.calls_received_challenge_decision_applicable?
        Metric::NOT_PROVIDED
      else
        Metric::NOT_APPLICABLE
      end
    end
  end

  def perform_transaction
    if metrics.calls_received_perform_transaction
      metrics.calls_received_perform_transaction
    else
      if service.calls_received_perform_transaction_applicable?
        Metric::NOT_PROVIDED
      else
        Metric::NOT_APPLICABLE
      end
    end
  end

  def other
    if metrics.calls_received_other
      metrics.calls_received_other
    else
      if service.calls_received_other_applicable?
        Metric::NOT_PROVIDED
      else
        Metric::NOT_APPLICABLE
      end
    end
  end

  def sampled
    raise NotImplementedError
  end

  def sampled_total
    raise NotImplementedError
  end

private

  attr_reader :metrics, :service
end
