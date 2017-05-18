class ServicesController < ApplicationController
  def index
    services = Service.all
    services_metrics = services.map {|service| ServiceMetricsPresenter.new(service, TimePeriod.default) }
    render json: services_metrics
  end

  def show
    service = Service.where(natural_key: params[:id]).first
    service_metrics = ServiceMetricsPresenter.new(service, TimePeriod.default)
    render json: service_metrics
  end
end
