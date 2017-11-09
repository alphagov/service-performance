class DepartmentMetricsController < MetricsController
  def index
    department = Department.where(natural_key: params[:department_id]).first!
    metrics = DepartmentMetrics.new(department, group_by: group_by, time_period: time_period)

    respond_to do |format|
      format.json { render json: metrics }
      format.csv { render csv: MetricsCSVExporter.new(metrics.published_monthly_service_metrics) }
    end
  end
end
