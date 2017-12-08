module ViewData
  class DeliveryOrganisationsController < ViewDataController
    def show
      @delivery_organisation = DeliveryOrganisation.where(natural_key: params[:id]).first!

      @metrics = MetricsPresenter.new(@delivery_organisation, group_by: Metrics::GroupBy::DeliveryOrganisation)

      page.title = @delivery_organisation.name

      page.breadcrumbs << Page::Crumb.new('UK Government', view_data_government_metrics_path)
      page.breadcrumbs << Page::Crumb.new(@delivery_organisation.department.name, view_data_department_path(id: @delivery_organisation.department))
      page.breadcrumbs << Page::Crumb.new(@delivery_organisation.name)

      respond_to do |format|
        format.html
        format.csv { render csv: MetricsCSVExporter.new(@metrics.published_monthly_service_metrics) }
      end
    end
  end
end
