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
    'transactions received - email',
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
        csv << [
          format_month(metric.month),
          metric.service.name,
          metric.department.name,
          metric.delivery_organisation.name,
          metric.service.start_page_url,
          format_metric(metric.transactions_received_metric.total),
          format_metric(metric.transactions_received_metric.online),
          format_metric(metric.transactions_received_metric.phone),
          format_metric(metric.transactions_received_metric.email),
          format_metric(metric.transactions_received_metric.paper),
          format_metric(metric.transactions_received_metric.face_to_face),
          format_metric(metric.transactions_received_metric.other),
          format_metric(metric.transactions_processed_metric.total),
          format_metric(metric.transactions_processed_metric.with_intended_outcome),
          format_metric(metric.calls_received_metric.total),
          format_metric(metric.calls_received_metric.get_information),
          format_metric(metric.calls_received_metric.perform_transaction),
          format_metric(metric.calls_received_metric.chase_progress),
          format_metric(metric.calls_received_metric.challenge_a_decision),
          format_metric(metric.calls_received_metric.other),
        ]
      end
    end
  end

private

  def format_month(month)
    month.to_formatted_s(:short_month_year)
  end

  def format_metric(metric)
    case metric
    when Metric::NOT_APPLICABLE
      'N/A'
    when Metric::NOT_PROVIDED
      'N/P'
    else
      metric
    end
  end
end

MonthlyCsvExporter = MetricsCSVExporter
