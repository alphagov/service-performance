class GovernmentMetricsController < ApplicationController
  def index
    client = CrossGovernmentServiceDataAPI::Client.new
    @metrics = GovernmentMetricsPresenter.new(client: client, group_by: params[:group_by])
    render 'metrics/index'
  end
end
