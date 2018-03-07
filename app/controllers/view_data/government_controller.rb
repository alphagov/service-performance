module ViewData
  class GovernmentController < ViewDataController
    def missing
      @government = Government.new
      @referer = previous_url
      @time_period = time_period

      calc = MissingDataCalculator.new(@government, @time_period)
      @missing_data = calc.missing_data
    end

    def show
      @government = Government.new
      @time_period = time_period

      @metrics = MetricsPresenter.new(@government, group_by: Metrics::GroupBy::Service, time_period: time_period)
      @previous = MetricsPresenter.new(@government, group_by: Metrics::GroupBy::Service, time_period: time_period.previous_period)

      @current_by_metrics = @metrics.metric_groups.first.sorted_metrics_by_month
      @previous_by_metrics = @previous.metric_groups.first.sorted_metrics_by_month

      page.title = @government.name

      respond_to do |format|
        format.html
        format.csv { render csv: MetricsCSVExporter.new(@metrics.published_monthly_service_metrics) }
      end
    end
  end
end
