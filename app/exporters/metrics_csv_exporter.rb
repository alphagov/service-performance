require 'csv'

class MetricsCSVExporter
  HEADERS = [
    'Month',
    'Service Name',
    'Department',
    'Delivery Organisation',
    'Service URL',
    'transactions received',
    'transactions received - online',
    'transactions received - phone',
    'transactions received - paper',
    'transactions received - face-to-face',
    'transactions received - other',
    'transactions ending in outcome',
    'transactions ending in intended outcome',
    'calls received - total',
    'calls received - get information',
    'calls received - perform a transaction',
    'calls received - chase progress',
    'calls received - challenge a decision',
    'calls received - other',
  ].freeze

  def initialize(metrics)
    @metrics = metrics.preload(service: { delivery_organisation: :department })
  end

  attr_reader :metrics

  def to_csv
    CSV.generate do |csv|
      csv << HEADERS

      metrics.each do |metric|
        service = metric.service

        csv << [
          format_month(metric.month),
          metric.service.name,
          metric.department.name,
          metric.delivery_organisation.name,
          metric.service.start_page_url,
          format_metric(metric.transactions_received),
          format_metric(metric.online_transactions, applicable: service.online_transactions_applicable),
          format_metric(metric.phone_transactions, applicable: service.phone_transactions_applicable),
          format_metric(metric.paper_transactions, applicable: service.paper_transactions_applicable),
          format_metric(metric.face_to_face_transactions, applicable: service.face_to_face_transactions_applicable),
          format_metric(metric.other_transactions, applicable: service.other_transactions_applicable),
          format_metric(metric.transactions_processed, applicable: service.transactions_processed_applicable),
          format_metric(metric.transactions_processed_with_intended_outcome, applicable: service.transactions_processed_with_intended_outcome_applicable),
          format_metric(metric.calls_received, applicable: service.calls_received_applicable),
          format_metric(metric.calls_received_get_information, applicable: service.calls_received_get_information_applicable),
          format_metric(metric.calls_received_perform_transaction, applicable: service.calls_received_perform_transaction_applicable),
          format_metric(metric.calls_received_chase_progress, applicable: service.calls_received_chase_progress_applicable),
          format_metric(metric.calls_received_challenge_decision, applicable: service.calls_received_challenge_decision_applicable),
          format_metric(metric.calls_received_other, applicable: service.calls_received_other_applicable),
        ]
      end
    end
  end

private

  def format_month(month)
    month.to_formatted_s(:short_month_year)
  end

  def format_metric(metric, applicable: true)
    if applicable
      metric.presence || 'N/P'
    else
      'N/A'
    end
  end
end

MonthlyCsvExporter = MetricsCSVExporter
