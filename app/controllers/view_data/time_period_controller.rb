module ViewData
  class TimePeriodController < ViewDataController
    def edit
      @time_period = time_period
      @referer = previous_url
      @settings = TimePeriodSettings.new("range": 12)
    end

    def update
      attrs = params.permit(:next, :range, :start_date_month, :start_date_year, :end_date_month, :end_date_year)

      @time_period = time_period
      @referer = previous_url
      @settings = TimePeriodSettings.new(attrs)
      if @settings.valid?
        persist_time_period_data(@settings)
        redirect_to @referer
      else
        render 'view_data/time_period/edit', referer: @referer, settings: @settings
      end
    end

  private

    def persist_time_period_data(settings)
      range = settings.range
      if range == "custom"
        start_date = Date.new(settings.start_date_year.to_i, settings.start_date_month.to_i).beginning_of_month
        end_date = Date.new(settings.end_date_year.to_i, settings.end_date_month.to_i).end_of_month
        tp = TimePeriod.new(start_date, end_date)
      elsif [12, 24, 36].include?(range.to_i)
        tp = TimePeriod.from_number_previous_months(range.to_i)
      else
        tp = TimePeriod.default
      end
      session[:time_period_range] = TimePeriod.serialise(tp)
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
