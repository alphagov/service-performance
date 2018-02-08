module ViewData
  class DepartmentsController < ViewDataController
    def show
      @department = Department.where(natural_key: params[:id]).first!

      @metrics = MetricsPresenter.new(@department, group_by: Metrics::GroupBy::Department, time_period: time_period)

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

      # This is just an example of usage
      @missing_data = []
      prng = Random.new
      4.times do |i|
        d = MissingData.new("Service #{i + 1}", prng.rand(99))
        d.add_metrics("Online transactions received", prng.rand(99), "")
        d.add_metrics("Phone transactions received", prng.rand(99), "")
        @missing_data << d
      end
    end
  end
end
