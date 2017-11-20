module Api
  class MetricsController < APIController
  private

    def time_period
      @time_period ||= TimePeriod.default
    end

    def group_by
      @group_by ||= params[:group_by] && params[:group_by].to_sym
    end
  end
end
