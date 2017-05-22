class ServicesController < ApplicationController

  def index
    client = CrossGovernmentServiceDataAPI::Client.new
    @metrics = DepartmentMetricsPresenter.new(client: client, department: params[:department_id])
    render 'metrics/index'
  end

  private

  helper_method :page
  def page
    OpenStruct.new(breadcrumbs: [])
  end

end
