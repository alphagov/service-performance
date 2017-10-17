class DeliveryOrganisationDownloadController < MetricsController
  def index
    delivery_org = DeliveryOrganisation.where(natural_key: params[:delivery_organisation_id]).first!
    raw = RawDeliveryOrganisationMetrics.new(delivery_org, time_period: time_period)

    respond_to do |format|
      format.csv {
        headers['Content-Type'] = "text/csv; charset=utf-8"
        headers['Content-Disposition'] = "attachment; filename=\"#{filename(delivery_org)}.csv\""
        self.response_body = raw.data
      }
    end
  end

private

  def filename(org)
    "#{org.name}-service-performance".parameterize
  end
end
