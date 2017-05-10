class FooTransactionsWithOutcomeMetricSerializer < ActiveModel::Serializer
  attributes :type, :total, :with_intended_outcome
end
