class ServicesController < ViewDataController
  def show
    client = GovernmentServiceDataAPI::Client.new
    @service = client.service(params[:id])

    @metrics = ServiceMetricsPresenter.new(@service, client: client, group_by: Metrics::Group::Service)

    page.title = @service.name

    page.breadcrumbs << Page::Crumb.new('UK Government', government_metrics_path)
    page.breadcrumbs << Page::Crumb.new(@service.department.name, department_metrics_path(department_id: @service.department.key))

    if @service.delivery_organisation
      page.breadcrumbs << Page::Crumb.new(@service.delivery_organisation.name, delivery_organisation_metrics_path(delivery_organisation_id: @service.delivery_organisation.key))
    end

    page.breadcrumbs << Page::Crumb.new(@service.name)
  end
end
