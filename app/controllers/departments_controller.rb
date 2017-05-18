class DepartmentsController < ApplicationController
  def index
    departments = Department.all
    departments_metrics = departments.map {|department| DepartmentMetricsPresenter.new(department, TimePeriod.default) }
    render json: departments_metrics
  end

  def show
    department = Department.where(natural_key: params[:id]).first
    department_metrics = DepartmentMetricsPresenter.new(department, TimePeriod.default)
    render json: department_metrics
  end
end
