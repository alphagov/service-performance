class DepartmentMetricsController < MetricsController
  def index
    department = client.department(params[:department_id])
    @metrics = DepartmentMetricsPresenter.new(department, client: client, group_by: group_by, order: order, order_by: order_by)
    render 'metrics/index'
  end
end
