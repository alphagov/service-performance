class TransactionsProcessedMetric < Metric
  define do
    item :total, from: ->(metrics) { metrics.transactions_processed }, applicable: ->(metrics) { metrics.service.transactions_processed_applicable? }
    item :with_intended_outcome, from: ->(metrics) { metrics.transactions_processed_with_intended_outcome }, applicable: ->(metrics) { metrics.service.transactions_processed_with_intended_outcome_applicable? }

    percentage_of :total
  end

  def name_to_db_name(name)
    case name
    when :total
      :transactions_processed
    when :with_intended_outcome
      :transactions_processed_with_intended_outcome
    end
  end
end
