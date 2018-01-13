module ViewData
  class GovernmentMetricsController < MetricsController
    def index
      @query = params[:q]

      government = Government.new
      @metrics = MetricsPresenter.new(government, group_by: group_by, order_by: order_by, order: order, search_term: @query)

      page.breadcrumbs << Page::Crumb.new('UK Government')

      respond_to do |format|
        format.html { render 'view_data/metrics/index' }
        format.csv { render csv: MetricsCSVExporter.new(@metrics.published_monthly_service_metrics) }
      end
    end
  end
end
