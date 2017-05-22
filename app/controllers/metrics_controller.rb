class MetricsController < ApplicationController

  def index
    client = CrossGovernmentServiceDataAPI::Client.new
    @metrics = GovernmentMetricsPresenter.new(client: client)
  end

  protected

  helper_method :page
  def page
    OpenStruct.new(breadcrumbs: [])
  end
end
