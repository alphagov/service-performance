class DeliveryOrganisationMetricsController < MetricsController
  def index
    delivery_organisation = DeliveryOrganisation.where(natural_key: params[:delivery_organisation_id]).first!
    metrics = DeliveryOrganisationMetrics.new(delivery_organisation, group_by: group_by, time_period: time_period)
    render json: metrics
  end
end
