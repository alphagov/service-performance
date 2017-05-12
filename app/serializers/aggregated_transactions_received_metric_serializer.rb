class AggregatedTransactionsReceivedMetricSerializer < ActiveModel::Serializer
  attributes :type, :total, :online, :phone, :paper, :face_to_face, :other

  def type
    'transactions-received'
  end
end
