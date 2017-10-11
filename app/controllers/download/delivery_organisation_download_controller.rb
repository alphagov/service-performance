class DeliveryOrganisationDownloadController < MetricsController
  def index
    delivery_org = DeliveryOrganisation.where(natural_key: params[:delivery_organisation_id]).first!
    raw = RawDeliveryOrganisationMetrics.new(delivery_org, time_period: time_period)
    render body: raw.data, content_type: "text/csv"
  end
end
