class AggregatedTransactionsReceivedMetricSerializer < ActiveModel::Serializer
  extend MetricSerializer

  attributes :type
  metrics :total, :online, :phone, :paper, :face_to_face, :other

  def type
    'transactions-received'
  end
end
