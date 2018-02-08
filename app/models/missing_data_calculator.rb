class MissingDataCalculator

  def initialize(entity, time_period)
    services = entity.services.all

    metrics = MonthlyServiceMetrics.joins(:service)
      .between(time_period.start_month, time_period.end_month)
      .where(service_id: services.map(&:id))
      .published
      .order("services.name")

    services_hash = services.each_with_object({}) { |obj, memo| memo[obj.id] = obj }
    metrics_hash = metrics.group_by { |m| m.service.id }

    @missing_data = []
  end

  attr_reader :missing_data
end
