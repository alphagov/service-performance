module ViewData
  class DepartmentMetricsController < MetricsController
    def index
      @query = params[:q]

      department = Department.where(natural_key: params[:department_id]).first!
      @metrics = MetricsPresenter.new(department, group_by: group_by, order: order, order_by: order_by, search_term: @query)

      page.breadcrumbs << Page::Crumb.new('UK Government', view_data_government_metrics_path)
      page.breadcrumbs << Page::Crumb.new(department.name)

      respond_to do |format|
        format.html { render 'view_data/metrics/index' }
        format.csv { render csv: MetricsCSVExporter.new(@metrics.published_monthly_service_metrics) }
      end
    end
  end
end
