class ViewDataController < ApplicationController
  layout 'view_data'

private

  def time_period
    TimePeriod.deserialise(session[:time_period]) || TimePeriod.default
  end
end
