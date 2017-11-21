class TransactionsReceivedMetric < Metric
  define do
    item :online, from: ->(metrics) { metrics.online_transactions }, applicable: ->(metrics) { metrics.service.online_transactions_applicable? }
    item :phone, from: ->(metrics) { metrics.phone_transactions }, applicable: ->(metrics) { metrics.service.phone_transactions_applicable? }
    item :paper, from: ->(metrics) { metrics.paper_transactions }, applicable: ->(metrics) { metrics.service.paper_transactions_applicable? }
    item :face_to_face, from: ->(metrics) { metrics.face_to_face_transactions }, applicable: ->(metrics) { metrics.service.face_to_face_transactions_applicable? }
    item :other, from: ->(metrics) { metrics.other_transactions }, applicable: ->(metrics) { metrics.service.other_transactions_applicable? }

    percentage_of :total
  end

  def total
    values.reduce(&method(:sum))
  end
end
