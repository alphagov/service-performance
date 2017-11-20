class GovernmentMetricsController < MetricsController
  def index
    government = client.government
    @metrics = GovernmentMetricsPresenter.new(government, client: client, group_by: group_by, order_by: order_by, order: order)

    page.breadcrumbs << Page::Crumb.new('UK Government')

    render 'metrics/index'
  end
end
