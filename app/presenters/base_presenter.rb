class BasePresenter < SimpleDelegator
  alias :read_attribute_for_serialization :send

  def initialize(model, time_period)
    @model, @time_period = model, time_period
    super(@model)
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
end
