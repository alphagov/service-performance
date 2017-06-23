class DepartmentMetricsPresenter < MetricsPresenter
  def initialize(client:, department_id:, group:)
    department = client.department(department_id)
    super(department, client: client, group: group)
  end

  def has_departments?
    false
  end
end
