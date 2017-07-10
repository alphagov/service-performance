class DepartmentMetricsController < MetricsController
  def index
    department = Department.where(natural_key: params[:department_id]).first!
    metrics = DepartmentMetrics.new(department, group_by: group_by, time_period: time_period)
    render json: metrics
  end
end
