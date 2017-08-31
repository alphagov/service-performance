class AggregatedTransactionsWithOutcomeMetricSerializer < ActiveModel::Serializer
  extend MetricSerializer

  attributes :type
  metrics :total, :with_intended_outcome

  def type
    'transactions-with-outcome'
  end
end
