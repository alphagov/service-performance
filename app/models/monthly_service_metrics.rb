class MonthlyServiceMetrics < ApplicationRecord
  self.table_name = 'monthly_service_metrics'

  belongs_to :service
  has_one :delivery_organisation, through: :service
  has_one :department, through: :service

  attribute :month, YearMonth::Serializer.new

  validates_uniqueness_of :month, scope: :service, strict: true

  scope :unpublished, -> { where(published: false) }

  def self.between(start_month, end_month)
    serializer = YearMonth::Serializer.new
    where('month >= :start AND month <= :end', start: serializer.serialize(start_month), end: serializer.serialize(end_month))
  end

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

  def transactions_received
    [online_transactions, phone_transactions, paper_transactions, face_to_face_transactions, other_transactions].compact.sum
  end
end
