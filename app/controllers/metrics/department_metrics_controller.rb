class DepartmentMetricsController < MetricsController
  def index
    department = client.department(params[:department_id])
    @metrics = DepartmentMetricsPresenter.new(department, client: client, group_by: group_by, order: order, order_by: order_by)

    page.breadcrumbs << Page::Crumb.new('UK Government', government_metrics_path)
    page.breadcrumbs << Page::Crumb.new(department.name)

    render 'metrics/index'
  end
end
