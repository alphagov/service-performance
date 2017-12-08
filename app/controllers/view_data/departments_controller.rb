module ViewData
  class DepartmentsController < ViewDataController
    def show
      @department = Department.where(natural_key: params[:id]).first!

      @metrics = MetricsPresenter.new(@department, group_by: Metrics::GroupBy::Department)

      page.title = @department.name

      page.breadcrumbs << Page::Crumb.new('UK Government', view_data_government_metrics_path)
      page.breadcrumbs << Page::Crumb.new(@department.name)

      respond_to do |format|
        format.html
        format.csv { render csv: MetricsCSVExporter.new(@metrics.published_monthly_service_metrics) }
      end
    end
  end
end
