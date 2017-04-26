class DepartmentDataPresenter < BasePresenter
  def department
    @model
  end

	private
	  def channel_summary
	  	@channel_summary ||= DepartmentChannelSummary.new(
	  		department: @model, time_period: @time_period)
	  end

	  def outcome_summary
	  	@outcome_summary ||= DepartmentOutcomeSummary.new(
	  		department: @model, time_period: @time_period)
	  end
end
