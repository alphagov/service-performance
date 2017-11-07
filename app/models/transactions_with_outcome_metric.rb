class TransactionsWithOutcomeMetric < Metric
  define do
    item :total, from: ->(metrics) { metrics.transactions_with_outcome }, applicable: ->(metrics) { metrics.service.transactions_with_outcome_applicable? }
    item :with_intended_outcome, from: ->(metrics) { metrics.transactions_with_intended_outcome }, applicable: ->(metrics) { metrics.service.transactions_with_intended_outcome_applicable? }
  end
end
