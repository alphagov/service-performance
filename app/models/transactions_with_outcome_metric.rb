class TransactionsWithOutcomeMetric
  def initialize(metrics)
    @metrics = metrics
    @service = metrics.service
  end

  def total
    if metrics.transactions_with_outcome
      metrics.transactions_with_outcome
    else
      if service.transactions_with_outcome_applicable?
        Metric::NOT_PROVIDED
      else
        Metric::NOT_APPLICABLE
      end
    end
  end

  def with_intended_outcome
    if metrics.transactions_with_intended_outcome
      metrics.transactions_with_intended_outcome
    else
      if service.transactions_with_intended_outcome_applicable?
        Metric::NOT_PROVIDED
      else
        Metric::NOT_APPLICABLE
      end
    end
  end

private

  attr_reader :metrics, :service
end
