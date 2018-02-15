module ViewData
  class GovernmentController < ViewDataController
    def missing
      @government = Government.new
      @referer = previous_url
      @time_period = time_period

      calc = MissingDataCalculator.new(@government, @time_period)
      @missing_data = calc.missing_data
    end
  end
end
