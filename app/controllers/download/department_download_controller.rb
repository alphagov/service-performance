class DepartmentDownloadController < MetricsController
  def index
    department = Department.where(natural_key: params[:department_id]).first!
    raw = RawDepartmentMetrics.new(department, time_period: time_period)
    render body: raw.data, content_type: "text/csv"
  end
end
