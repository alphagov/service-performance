class MetricsController < ApplicationController
private

  def group_by
    @group_by ||= params[:group_by] && params[:group_by].to_sym
  end

  def time_period
    @time_period ||= TimePeriod.default
  end
end
