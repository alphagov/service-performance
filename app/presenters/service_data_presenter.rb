class ServiceDataPresenter < BasePresenter
  def service
    @model
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
