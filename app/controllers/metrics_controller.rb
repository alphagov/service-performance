class MetricsController < ApplicationController

  def index
    client = CrossGovernmentServiceDataAPI::Client.new
    @metrics = GovernmentMetricsPresenter.new(client: client)
  end

end
