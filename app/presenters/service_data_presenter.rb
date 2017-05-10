class ServiceDataPresenter < BasePresenter
  def service
    @model
  end

  def metrics
    [
      TransactionsReceivedMetric.new(
        online: transactions_received_online,
        phone: transactions_received_phone,
        paper: transactions_received_paper,
        face_to_face: transactions_received_face_to_face,
        other: transactions_received_other
      ),
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
