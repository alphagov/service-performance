class TransactionsWithOutcomeMetricSerializer < ActiveModel::Serializer
  extend MetricSerializer

  attributes :type, :completeness
  metrics :total, :with_intended_outcome

  def type
    'transactions-with-outcome'
  end
end
