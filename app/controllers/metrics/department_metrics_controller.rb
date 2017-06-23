class DepartmentMetricsController < ApplicationController
  def index
    client = CrossGovernmentServiceDataAPI::Client.new
    @metrics = DepartmentMetricsPresenter.new(client: client, department_id: params[:department_id], group: params[:group])
    render 'metrics/index'
  end
end
