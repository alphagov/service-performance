module ViewData
  class DeliveryOrganisationMetricsController < MetricsController
    def index
      delivery_organisation = DeliveryOrganisation.where(natural_key: params[:delivery_organisation_id]).first!
      @metrics = MetricsPresenter.new(delivery_organisation, group_by: group_by, order: order, order_by: order_by)

      page.breadcrumbs << Page::Crumb.new('UK Government', view_data_government_metrics_path)
      page.breadcrumbs << Page::Crumb.new(delivery_organisation.department.name, view_data_department_metrics_path(department_id: delivery_organisation.department))
      page.breadcrumbs << Page::Crumb.new(delivery_organisation.name)

      render 'view_data/metrics/index'
    end
  end
end
