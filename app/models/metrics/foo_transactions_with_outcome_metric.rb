class FooTransactionsWithOutcomeMetric
  alias :read_attribute_for_serialization :send

  attr_accessor :total, :with_intended_outcome

  def initialize(attributes = {})
    @total = attributes[:total]
    @with_intended_outcome = attributes[:with_intended_outcome]
  end

  def type
    'foo-transactions-with-outcome'
  end
end
