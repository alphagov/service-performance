class DepartmentMetricsPresenter
  include Rails.application.routes.url_helpers

  def initialize(client:, department:)
    @client = client
    @data = client.services_metrics_by_department(department)
  end

  def organisation_count
    @data.count
  end

  def organisation_singular_noun
    'service'
  end

  def organisation_plural_noun
    'services'
  end

  def parent_organisation
    @data.first.department.name
  end

  def groups
    @data.map do |data|
      name = data.service.name
      url = department_service_path(data.department.key, data.service.key)
      MetricGroup.new(name, url, data.metrics)
    end
  end
end
