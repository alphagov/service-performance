class GovernmentMetricsController < ApplicationController
  def index
    client = CrossGovernmentServiceDataAPI::Client.new
    @metrics = GovernmentMetricsPresenter.new(client: client, group: params[:group])
    render 'metrics/index'
  end
end
