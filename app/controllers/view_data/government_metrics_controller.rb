module ViewData
  class GovernmentMetricsController < MetricsController
    def index
      government = Government.new
      @metrics = MetricsPresenter.new(government, group_by: group_by, order_by: order_by, order: order, time_period: time_period)

      page.breadcrumbs << Page::Crumb.new('UK Government')

      respond_to do |format|
        format.html { render 'view_data/metrics/index' }
        format.csv { render csv: MetricsCSVExporter.new(@metrics.published_monthly_service_metrics) }
      end
    end
  end
end
