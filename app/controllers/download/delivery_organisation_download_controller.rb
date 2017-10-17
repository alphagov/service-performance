class DeliveryOrganisationDownloadController < MetricsController
  def index
    delivery_org = DeliveryOrganisation.where(natural_key: params[:delivery_organisation_id]).first!
    raw = RawDeliveryOrganisationMetrics.new(delivery_org, time_period: time_period)
    headers['Content-Disposition'] = "attachment; filename=\"#{filename(delivery_org)}.csv\""
    render body: raw.data.to_a.join(""), content_type: "text/csv"
  end

private

  def filename(org)
    "#{org.name}-service-performance.csv".parameterize
  end
end
