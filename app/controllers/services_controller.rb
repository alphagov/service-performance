class ServicesController < ApplicationController

  def index
    client = CrossGovernmentServiceDataAPI::Client.new
    @metrics = DepartmentMetricsPresenter.new(client: client, department: params[:department_id])
    render 'metrics/index'
  end

  def show
    client = CrossGovernmentServiceDataAPI::Client.new
    @service = client.service(params[:id])

    page.title = @service.name
  end

end
