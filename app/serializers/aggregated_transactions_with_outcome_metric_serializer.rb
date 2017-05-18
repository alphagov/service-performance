class AggregatedTransactionsWithOutcomeMetricSerializer < ActiveModel::Serializer
  attributes :type, :total, :with_intended_outcome

  def type
    'transactions-with-outcome'
  end
end
