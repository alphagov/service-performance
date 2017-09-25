class MonthlyServiceMetrics < ApplicationRecord
  self.table_name = 'monthly_service_metrics'

  belongs_to :service

  attribute :month, YearMonth::Serializer.new

  def publish_date
    if month
      month.date + 2.months
    end
  end

  def next_metrics_due_date
    if month
      month.date + 1.month
    end
  end
end
