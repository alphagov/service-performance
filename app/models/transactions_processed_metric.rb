class TransactionsProcessedMetric < Metric
  define do
    item :total, from: ->(metrics) { metrics.transactions_processed }, applicable: ->(metrics) { metrics.service.transactions_processed_applicable? }
    item :accepted, from: ->(metrics) { metrics.transactions_processed_accepted }, applicable: ->(metrics) { metrics.service.transactions_processed_accepted_applicable? }
    item :rejected, from: ->(metrics) { metrics.transactions_processed_rejected }, applicable: ->(metrics) { metrics.service.transactions_processed_rejected_applicable? }

    percentage_of :total
  end

  def name_to_db_name(name)
    case name
    when :total
      :transactions_processed
    when :accepted
      :transactions_processed_accepted
    when :rejected
      :transactions_processed_rejected
    end
  end
end
