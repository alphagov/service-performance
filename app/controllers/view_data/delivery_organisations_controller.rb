module ViewData
  class DeliveryOrganisationsController < ViewDataController
    def show
      @delivery_organisation = DeliveryOrganisation.where(natural_key: params[:id]).first!

      @metrics = MetricsPresenter.new(@delivery_organisation, group_by: Metrics::GroupBy::DeliveryOrganisation, time_period: time_period)

      page.title = @delivery_organisation.name

      page.breadcrumbs << Page::Crumb.new('UK Government', view_data_government_metrics_path)
      page.breadcrumbs << Page::Crumb.new(@delivery_organisation.department.name, view_data_department_path(id: @delivery_organisation.department))
      page.breadcrumbs << Page::Crumb.new(@delivery_organisation.name)

      respond_to do |format|
        format.html
        format.csv { render csv: MetricsCSVExporter.new(@metrics.published_monthly_service_metrics) }
      end
    end

    def missing
      @delivery_organisation = DeliveryOrganisation.where(natural_key: params[:delivery_organisation_id]).first!
      @referer = previous_url
      @time_period = time_period

      # This is just an example of usage
      @missing_data = []
      prng = Random.new
      4.times do |i|
        d = MissingData.new("Service #{i + 1}", prng.rand(99))
        d.add_metrics("Online transactions received", prng.rand(99), "")
        d.add_metrics("Phone transactions received", prng.rand(99), "")
        @missing_data << d
      end
    end
  end
end
