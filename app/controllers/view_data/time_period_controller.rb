module ViewData
  class TimePeriodController < ViewDataController
    def edit; end

    def update
      success = false
      if success
        # Redirect to previous
      else
        render 'view_data/time_period/edit'
      end
    end
  end
end
