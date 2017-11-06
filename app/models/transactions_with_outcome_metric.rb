class TransactionsWithOutcomeMetric
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
      total: metric.(metrics.transactions_with_outcome, applicable: service.transactions_with_outcome_applicable?),
      with_intended_outcome: metric.(metrics.transactions_with_intended_outcome, applicable: service.transactions_with_intended_outcome_applicable?),
    )
  end

  def initialize(total:, with_intended_outcome:)
    @total = total
    @with_intended_outcome = with_intended_outcome
  end

  def applicable?
    [total, with_intended_outcome].any? { |value| value != Metric::NOT_APPLICABLE }
  end

  attr_reader :total, :with_intended_outcome

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
      with_intended_outcome: sum.(self.with_intended_outcome, other.with_intended_outcome),
    )
  end
end
