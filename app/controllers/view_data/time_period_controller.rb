module ViewData
  class TimePeriodController < ViewDataController
    def edit
      @referer = previous_url
      @time_period = TimePeriod.default
    end

    def update
      @time_period = TimePeriod.default
      @referer = previous_url
      success = true
      if success
        #TODO where do we want to go if success? Permit params
        redirect_to @referer
      else
        render 'view_data/time_period/edit', referer: @referer
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
