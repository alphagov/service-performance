class ServicesController < ApplicationController
  def index
    if params[:department_id]
      department = Department.where(natural_key: params[:department_id]).first!
      services = department.services
    else
      department = nil
      services = Service.all
    end
    services_metrics = services.map {|service| ServiceMetricsPresenter.new(department, service, TimePeriod.default) }
    render json: services_metrics
  end

  def show
    service = Service.where(natural_key: params[:id]).first
    service_metrics = ServiceMetricsPresenter.new(service.department, service, TimePeriod.default)
    render json: service_metrics
  end
end
