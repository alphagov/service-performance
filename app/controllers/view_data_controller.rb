class ViewDataController < ApplicationController
  layout 'view_data'

private

  def time_period
    session[:time_period] || TimePeriod.default
  end
end
