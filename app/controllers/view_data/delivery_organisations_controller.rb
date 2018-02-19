module ViewData
  class DeliveryOrganisationsController < ViewDataController
    def show
      @delivery_organisation = DeliveryOrganisation.where(natural_key: params[:id]).first!

      @metrics = MetricsPresenter.new(@delivery_organisation, group_by: Metrics::GroupBy::DeliveryOrganisation, time_period: time_period)
      @previous = MetricsPresenter.new(@delivery_organisation, group_by: Metrics::GroupBy::DeliveryOrganisation, time_period: time_period.previous_period)

      @current_by_metrics = @metrics.metric_groups.last.sorted_metrics_by_month
      @previous_by_metrics = @previous.metric_groups.last.sorted_metrics_by_month

      page.title = @delivery_organisation.name

      respond_to do |format|
        format.html
        format.csv { render csv: MetricsCSVExporter.new(@metrics.published_monthly_service_metrics) }
      end
    end

    def missing
      @delivery_organisation = DeliveryOrganisation.where(natural_key: params[:delivery_organisation_id]).first!
      @referer = previous_url
      @time_period = time_period

      calc = MissingDataCalculator.new(@delivery_organisation, @time_period)
      @missing_data = calc.missing_data
    end
  end
end
