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

      MetricGroup.new(name, url, data.metrics)
    end
  end
end
