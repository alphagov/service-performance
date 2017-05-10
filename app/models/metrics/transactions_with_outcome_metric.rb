class TransactionsWithOutcomeMetric < Metric

  type 'transactions-with-outcome'

  # The number of transactions where no further changes to the user's
  # relationship with government will be made in response to their request.
  attribute :total

  # A subset of the transactions ending in an outcome where the outcome is what
  # the user set out to achieve.
  attribute :with_intended_outcome

end
