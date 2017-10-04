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
    @metrics = metrics.preload(:department).preload(:delivery_organisation)
  end

  attr_reader :metrics

  def to_csv
    CSV.generate do |csv|
      csv << HEADERS

      metrics.each do |metric|
        csv << [
          format_month(metric.month),
          metric.service.name,
          metric.department.name,
          metric.delivery_organisation.name,
          metric.service.start_page_url,
          format_metric(metric.transactions_received),
          format_metric(metric.online_transactions),
          format_metric(metric.phone_transactions),
          format_metric(metric.paper_transactions),
          format_metric(metric.face_to_face_transactions),
          format_metric(metric.other_transactions),
          format_metric(metric.transactions_with_outcome),
          format_metric(metric.transactions_with_intended_outcome),
          format_metric(metric.calls_received),
          format_metric(metric.calls_received_get_information),
          format_metric(metric.calls_received_chase_progress),
          format_metric(metric.calls_received_challenge_decision),
          format_metric(metric.calls_received_other),
          format_metric(metric.calls_received_perform_transaction),
        ]
      end
    end
  end

private

  def format_month(month)
    month.to_formatted_s(:short_month_year)
  end

  def format_metric(metric)
    metric.presence || 'N/P'
  end
end
