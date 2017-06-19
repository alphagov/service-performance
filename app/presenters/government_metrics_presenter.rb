class GovernmentMetricsPresenter
  include Rails.application.routes.url_helpers

  def initialize(client:)
    @client = client
    @data = client.metrics_by_department
  end

  def organisation_name
    'UK government'
  end

  def groups
    @data.map do |data|
      case scope
      when DEPARTMENTS
        name = data.department.name
        url = department_services_path(data.department.key)
        delivery_organisations_count = data.department.delivery_organisations_count
        services_count = data.department.services_count

        MetricGroup.new(name, url, data.metrics, delivery_organisations_count: delivery_organisations_count, services_count: services_count)
      when SERVICES
        ServiceMetricGroup.new(data)
      end
    end
  end
end
