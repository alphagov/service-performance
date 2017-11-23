module ViewData
  class ServicesController < ViewDataController
    def show
      @service = Service.where(natural_key: params[:id]).first!

      @metrics = MetricsPresenter.new(@service, group_by: Metrics::GroupBy::Service)

      page.title = @service.name

      page.breadcrumbs << Page::Crumb.new('UK Government', view_data_government_metrics_path)
      page.breadcrumbs << Page::Crumb.new(@service.department.name, view_data_department_metrics_path(department_id: @service.department))

      if @service.delivery_organisation
        page.breadcrumbs << Page::Crumb.new(@service.delivery_organisation.name, view_data_delivery_organisation_metrics_path(delivery_organisation_id: @service.delivery_organisation))
      end

      page.breadcrumbs << Page::Crumb.new(@service.name)

      respond_to do |format|
        format.html
        format.csv { render csv: MetricsCSVExporter.new(@metrics.published_monthly_service_metrics) }
      end
    end
  end
end
