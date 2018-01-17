module ViewData
  class TimePeriodController < ViewDataController
    def edit
      @referer = previous_url
      @time_period = TimePeriod.default
      # TODO: Set the attributes in settings to the currently chosen time-period
    end

    def update
      attrs = params.permit(:next, :range, :start_date_month, :start_date_year, :end_date_month, :end_date_year)

      @time_period = TimePeriod.default
      @referer = previous_url
      @settings = TimePeriodSettings.new(attrs)
      @errors = @settings.errors

      if @settings.valid?
        redirect_to @referer
      else
        render 'view_data/time_period/edit', referer: @referer, settings: @settings, errors: @errors
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
