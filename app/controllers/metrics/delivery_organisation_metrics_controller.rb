class DeliveryOrganisationMetricsController < MetricsController
  def index
    delivery_organisation = client.delivery_organisation(params[:delivery_organisation_id])
    @metrics = DeliveryOrganisationMetricsPresenter.new(delivery_organisation, client: client, group_by: group_by, order: order, order_by: order_by)
    render 'metrics/index'
  end
end
