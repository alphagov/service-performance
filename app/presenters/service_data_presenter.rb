class ServiceDataPresenter < BasePresenter
  def service
    @model
  end

  def transactions_received_online
    channel_summary.transactions_received_online
  end

  def transactions_received_phone
  	channel_summary.transactions_received_phone
  end
  
  def transactions_received_paper
  	channel_summary.transactions_received_paper
  end
  
  def transactions_received_face_to_face
  	channel_summary.transactions_received_face_to_face
  end

  def transactions_received_other
  	channel_summary.transactions_received_other
  end

  def transactions_ending_any_outcome
  	outcome_summary.transactions_ending_any_outcome
  end

  def transactions_ending_user_intended_outcome
  	outcome_summary.transactions_ending_user_intended_outcome
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
