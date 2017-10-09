class ServiceDownloadController < ApplicationController
  def index
    service = Service.where(natural_key: params[:service_id]).first!
    raw = RawServiceMetrics.new(service, time_period: time_period)
    render body: raw.data, content_type: "text/plain"
  end

private

  def time_period
    @time_period ||= TimePeriod.default
  end
end
