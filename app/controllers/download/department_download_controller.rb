class DepartmentDownloadController < MetricsController
  def index
    department = Department.where(natural_key: params[:department_id]).first!
    raw = RawDepartmentMetrics.new(department, time_period: time_period)
    headers['Content-Disposition'] = "attachment; filename=\"#{filename(department)}.csv\""
    render body: raw.data.to_a.join(""), content_type: "text/csv"
  end

private

  def filename(dept)
    "#{dept.name}-service-performance".parameterize
  end
end
