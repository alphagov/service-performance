class GovernmentServiceDataAPI::TransactionsWithOutcomeMetric
  include GovernmentServiceDataAPI::MetricStatus

  def self.build(data)
    data ||= {}

    new(
      count: data.fetch('total', NOT_APPLICABLE),
      count_with_intended_outcome: data.fetch('with_intended_outcome', NOT_APPLICABLE),
    )
  end

  def initialize(count: nil, count_with_intended_outcome: nil)
    @count = count || NOT_PROVIDED
    @count_with_intended_outcome = count_with_intended_outcome || NOT_PROVIDED
  end

  attr_reader :count, :count_with_intended_outcome

  def not_applicable?
    [@count, @count_with_intended_outcome].all? { |item| item == NOT_APPLICABLE }
  end

  def not_provided?
    [@count, @count_with_intended_outcome].all? { |item| item == NOT_PROVIDED }
  end

  def with_intended_outcome_percentage
    return @count_with_intended_outcome if @count_with_intended_outcome.in? [NOT_PROVIDED, NOT_APPLICABLE]
    (@count_with_intended_outcome.to_f / @count) * 100
  end
end
