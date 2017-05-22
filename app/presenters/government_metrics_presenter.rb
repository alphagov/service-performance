class GovernmentMetricsPresenter
  include Rails.application.routes.url_helpers

  def initialize(client:)
    @client = client
    @data = client.metrics_by_department
  end

  def organisation_count
    @data.count
  end

  def organisation_singular_noun
    'department'
  end

  def organisation_plural_noun
    'departments'
  end

  def parent_organisation
    'UK government'
  end

  def groups
    @data.map do |data|
      name = data.department.name
      url = department_services_path(data.department.key)
      agencies_count = data.department.agencies_count
      services_count = data.department.services_count

      MetricGroup.new(name, url, data.metrics, agencies_count: agencies_count, services_count: services_count)
    end
  end
end
