class MetricsController < ApplicationController

  def index
    client = CrossGovernmentServiceDataAPI::Client.new
    @metrics = MetricsPresenter.new(data: client.metrics_by_department)
  end

  protected

  helper_method :page
  def page
    OpenStruct.new(breadcrumbs: [])
  end
end
