class GovernmentServiceDataAPI::NonApplicableMetric
  def initialize(mesg)
    @message = mesg
  end

  attr_reader :message
end
