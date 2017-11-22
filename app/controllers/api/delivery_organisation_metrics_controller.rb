module Api
  class DeliveryOrganisationMetricsController < MetricsController
    def index
      delivery_organisation = DeliveryOrganisation.where(natural_key: params[:delivery_organisation_id]).first!
      metrics = DeliveryOrganisationMetrics.new(delivery_organisation, group_by: group_by, time_period: time_period)

      respond_to do |format|
        format.json { render json: metrics }
        format.csv { render csv: MetricsCSVExporter.new(metrics.published_monthly_service_metrics) }
      end
    end
  end
end
