class ViewDataController < ApplicationController
  layout 'view_data'

private

  def time_period
    TimePeriod.deserialise(session[:time_period_range]) || TimePeriod.default
  end

  def previous_url
    path = params[:next] || request.referer
    return view_data_government_metrics_path if path.nil?

    path = URI.parse(path).path
    begin
      _ = Rails.application.routes.recognize_path(path)
      path
    rescue StandardError => _
      view_data_government_metrics_path
    end
  end
end
