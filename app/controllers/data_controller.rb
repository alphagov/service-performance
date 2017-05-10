class DataController < ApplicationController
  # GET /data/government
  # GET /data/government/:year/:quarter_from,:quarter_to
  def government
    render json: { route: '/data/government', params: params }
  end

  # GET /data/government/latest
  def government_latest
    render json: { route: '/data/government/latest', params: params }
  end

  # GET /data/departments
  def departments
    data = []
    Department.all.each do |department|
      data << DepartmentDataPresenter.new(department, TimePeriod.new)
    end
    render json: data
  end

  #GET /data/departments/:department_natural_key
  def department
    department = Department.find_by(
      natural_key: params[:department_natural_key])
    if department
      render json: DepartmentDataPresenter.new(department, TimePeriod.new)
    else
      render json: {
        route: '/data/departments/department_natural_key', params: params}
    end
  end

  # GET /data/services
  def services
    data = []
    Service.all.each do |service|
      data << ServiceDataPresenter.new(service, TimePeriod.new)
    end
    render json: data
  end

  #GET /data/services/:service_natural_key
  def service
    service = Service.find_by(natural_key: params[:service_natural_key])
    if service
      render json: ServiceDataPresenter.new(service, TimePeriod.new)
    else
      render json: {
        route: '/data/services/:service_natural_key', params: params}
    end
  end
end