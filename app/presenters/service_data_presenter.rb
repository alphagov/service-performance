class ServiceDataPresenter < BasePresenter
  def service
    @model
  end

  def metrics
    [
      FooTransactionsWithOutcomeMetric.new(
        total: transactions_ending_any_outcome,
        with_intended_outcome: transactions_ending_user_intended_outcome
      )
    ]
  end

	private
	  def channel_summary
	  	@channel_summary ||= ServiceChannelSummary.new(
	  		service: @model, time_period: @time_period)
	  end

	  def outcome_summary
	  	@outcome_summary ||= ServiceOutcomeSummary.new(
	  		service: @model, time_period: @time_period)
	  end
end
