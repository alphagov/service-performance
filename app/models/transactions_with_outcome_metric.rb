class TransactionsWithOutcomeMetric
  alias :read_attribute_for_serialization :send

  def self.to_proc
    ->(metrics) { new(metrics) }
  end

  def initialize(metrics)
    @metrics = metrics
    @service = metrics.service
  end

  def applicable?
    [total, with_intended_outcome].any? { |value| value != Metric::NOT_APPLICABLE }
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

  def completeness
    Completeness.new
  end

private

  attr_reader :metrics, :service
end
