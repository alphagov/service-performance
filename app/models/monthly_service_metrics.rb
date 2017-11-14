class MonthlyServiceMetrics < ApplicationRecord
  class Null
    def initialize(service, month)
      @service = service
      @month = month
    end

    attr_reader :service, :month

    attr_reader :online_transactions, :phone_transactions, :paper_transactions, :face_to_face_transactions, :other_transactions
    attr_reader :transactions_with_outcome, :transactions_with_intended_outcome
    attr_reader :calls_received, :calls_received_get_information, :calls_received_chase_progress, :calls_received_challenge_decision, :calls_received_other, :calls_received_perform_transaction
  end

  self.table_name = 'monthly_service_metrics'

  belongs_to :service
  has_one :delivery_organisation, through: :service
  has_one :department, through: :service

  attribute :month, YearMonth::Serializer.new

  validates_uniqueness_of :month, scope: :service, strict: true

  scope :published, -> { where(published: true) }
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
      month.date + 2.months
    end
  end

  def transactions_received
    [online_transactions, phone_transactions, paper_transactions, face_to_face_transactions, other_transactions].compact.sum
  end
end
