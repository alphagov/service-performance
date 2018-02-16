class MonthlyServiceMetrics < ApplicationRecord
  has_paper_trail
  validate :number_of_transactions

  def number_of_transactions
    if !transactions_processed_with_intended_outcome.nil?
      if transactions_processed_with_intended_outcome > transactions_processed
        errors.add(:transactions_processed_with_intended_outcome, "must be less than or equal to transactions processed")
      end
    end
  end

  class Null
    def initialize(service, month)
      @service = service
      @month = month
    end

    attr_reader :service, :month

    attr_reader :online_transactions, :phone_transactions, :paper_transactions, :face_to_face_transactions, :other_transactions
    attr_reader :transactions_processed, :transactions_processed_with_intended_outcome
    attr_reader :calls_received, :calls_received_get_information, :calls_received_chase_progress, :calls_received_challenge_decision, :calls_received_other, :calls_received_perform_transaction

    def transactions_received_metric
      @transactions_received_metric ||= TransactionsReceivedMetric.from_metrics(self)
    end

    def transactions_processed_metric
      @transactions_processed_metric ||= TransactionsProcessedMetric.from_metrics(self)
    end

    def calls_received_metric
      @calls_received_metric ||= CallsReceivedMetric.from_metrics(self, with_samples: true)
    end
  end

  def number_of_transactions
    if transactions_processed_with_intended_outcome.to_i > transactions_processed.to_i
      errors.add(:transactions_processed_with_intended_outcome, "must be less than or equal to transactions processed")
    end
  end

  def number_of_calls_received
    if calls_received_perform_transaction != phone_transactions
      errors.add(:calls_received_perform_transaction, "should be the same as the 'Number of transactions received, split by channel (phone)")
    end
  end

  def total_calls_received
    all_calls_all_reasons = [
      calls_received_perform_transaction,
      calls_received_get_information,
      calls_received_chase_progress,
      calls_received_challenge_decision,
      calls_received_other
    ]
    total_calls = all_calls_all_reasons.compact.sum

    if total_calls != 0 && calls_received.to_i != total_calls
      errors.add(:calls_received, "should be the sum of the fields within 'Number of phone calls received, split by reasons for calling'")
    end
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

  def missing_data?
    service.required_metrics.any? { |m|
      send(m) == nil
    }
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

  def transactions_received_metric
    @transactions_received_metric ||= TransactionsReceivedMetric.from_metrics(self)
  end

  def transactions_processed_metric
    @transactions_processed_metric ||= TransactionsProcessedMetric.from_metrics(self)
  end

  def calls_received_metric
    @calls_received_metric ||= CallsReceivedMetric.from_metrics(self, with_samples: true)
  end
end
