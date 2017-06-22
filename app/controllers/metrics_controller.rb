class MetricsController < ApplicationController
  private
  def group
    @group ||= params[:group] && params[:group].to_sym
  end

  def time_period
    @time_period ||= TimePeriod.default
  end
end
