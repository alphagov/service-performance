class DepartmentMetricsPresenter < MetricsPresenter
  def initialize(client:, department_id:, group_by:)
    department = client.department(department_id)
    super(department, client: client, group_by: group_by)
  end

  def has_departments?
    false
  end
end
