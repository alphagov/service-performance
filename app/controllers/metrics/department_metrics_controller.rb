class DepartmentMetricsController < MetricsController
  def index
    department = Department.where(natural_key: params[:department_id]).first!
    metrics = DepartmentMetrics.new(department, group: group, time_period: time_period)
    render json: metrics
  end
end
