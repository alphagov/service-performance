class DeliveryOrganisationMetricsController < MetricsController
  def index
    delivery_organisation = client.delivery_organisation(params[:delivery_organisation_id])
    @metrics = DeliveryOrganisationMetricsPresenter.new(delivery_organisation, client: client, group_by: group_by, order: order, order_by: order_by)

    page.breadcrumbs << Page::Crumb.new('UK Government', government_metrics_path)
    page.breadcrumbs << Page::Crumb.new(delivery_organisation.department.name, department_metrics_path(department_id: delivery_organisation.department.key))
    page.breadcrumbs << Page::Crumb.new(delivery_organisation.name)

    render 'metrics/index'
  end
end
