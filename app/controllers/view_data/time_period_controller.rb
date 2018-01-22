module ViewData
  class TimePeriodController < ViewDataController
    def edit
      @time_period = TimePeriod.default
      @referer = previous_url
      @settings = TimePeriodSettings.new({ "range": 12 })
    end

    def persist_time_period_data(settings)
      tp = case settings.range
           when "custom"

           else
             TimePeriod.from_number_previous_months(settings.range.to_i)
           else
             TimePeriod.default
           end
      session[:time_period] ||= tp.serialize
    end

    def update
      attrs = params.permit(:next, :range, :start_date_month, :start_date_year, :end_date_month, :end_date_year)

      @time_period = TimePeriod.default
      @referer = previous_url
      @settings = TimePeriodSettings.new(attrs)

      if @settings.valid?
        # TODO: Convert settings to time period, call serialize and store
        # in the session....
        persist_time_period_data(@settings)

        redirect_to @referer
      else
        render 'view_data/time_period/edit', referer: @referer, settings: @settings, errors: @settings.errors
      end
    end

    def previous_url
      path = params[:next] || request.referer
      return view_data_government_metrics_path if path.nil?

      path = URI.parse(path).path
      begin
        _ = Rails.application.routes.recognize_path(path)
        path
      rescue
        view_data_government_metrics_path
      end
    end
  end
end
