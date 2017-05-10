class FooTransactionsWithOutcomeMetric < ActiveModelSerializers::Model
  attributes :type, :total, :with_intended_outcome

  def type
    'foo-transactions-with-outcome'
  end
end
