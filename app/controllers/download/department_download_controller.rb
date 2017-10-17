class DepartmentDownloadController < MetricsController
  def index
    department = Department.where(natural_key: params[:department_id]).first!
    raw = RawDepartmentMetrics.new(department, time_period: time_period)

    respond_to do |format|
      format.csv {
        headers['Content-Type'] = "text/csv; charset=utf-8"
        headers['Content-Disposition'] = "attachment; filename=\"#{filename(department)}.csv\""
        self.response_body = raw.data
      }
    end
  end

private

  def filename(dept)
    "#{dept.name}-service-performance".parameterize
  end
end
