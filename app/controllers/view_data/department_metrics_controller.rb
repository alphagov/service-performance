module ViewData
  class DepartmentMetricsController < MetricsController
    def index
      department = Department.where(natural_key: params[:department_id]).first!
      @metrics = DepartmentMetricsPresenter.new(department, group_by: group_by, order: order, order_by: order_by)

      page.breadcrumbs << Page::Crumb.new('UK Government', view_data_government_metrics_path)
      page.breadcrumbs << Page::Crumb.new(department.name)

      render 'view_data/metrics/index'
    end
  end
end
