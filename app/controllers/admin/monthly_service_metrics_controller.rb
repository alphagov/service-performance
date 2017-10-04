module Admin
  class MonthlyServiceMetricsController < Admin::ApplicationController
    def resource_class
      MonthlyServiceMetrics
    end

    def dashboard_class
      MonthlyServiceMetricsDashboard
    end
  end
end
