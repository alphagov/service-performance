module ViewData
  class DepartmentsController < ViewDataController
    def show
      @department = Department.where(natural_key: params[:id]).first!

      @metrics = MetricsPresenter.new(@department, group_by: Metrics::GroupBy::Department, time_period: time_period)
      @previous = MetricsPresenter.new(@department, group_by: Metrics::GroupBy::Department, time_period: time_period.previous_period)

      page.title = @department.name

      page.breadcrumbs << Page::Crumb.new('UK Government', view_data_government_metrics_path)
      page.breadcrumbs << Page::Crumb.new(@department.name)

      respond_to do |format|
        format.html
        format.csv { render csv: MetricsCSVExporter.new(@metrics.published_monthly_service_metrics) }
      end
    end

    def missing
      @department = Department.where(natural_key: params[:department_id]).first!
      @referer = previous_url
      @time_period = time_period

      calc = MissingDataCalculator.new(@department, @time_period)
      @missing_data = calc.missing_data
    end
  end
end
