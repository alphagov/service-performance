require 'csv'

class RawMetrics
  MAPPING = {
    "Transactions Received - Online" => "online",
    "Transactions Received - Phone" => "phone",
    "Transactions Received - Paper" => "paper",
    "Transactions Received - Face to face" => "face_to_face",
    "Transactions Received - Other" => "channel-other",
    "Transactions Processed - Total" => "any",
    "Transactions Processed - Intended" => "intended",
    "Calls Received - Total" => "total",
    "Calls Received - Perform a transaction" => "perform-transaction",
    "Calls Received - Get information" => "get-information",
    "Calls Received - Chase Progress" => "chase-progress",
    "Calls Received - Challenge Decision" => "challenge-a-decision",
    "Calls Received - Other" => "item-other",
  }.freeze

  def header_row
    %w(Service Timestamp) + MAPPING.keys
  end

  def data
    return to_enum(:data) unless block_given?

    yield header_row.to_csv

    raw_metrics.each { |date, hash|
      row = [hash['department'], hash['agency'], hash['service'], date]

      MAPPING.each { |_key, val|
        row << hash.fetch(val, 'N/P')
      }
      yield row.to_csv
    }
  end

private

  def query
    raise NotImplementedError, "must be implemented by sub-classes"
  end

  def raw_metrics
    call_data = query(CallsReceivedMetric, 'item')
    trxn_data = query(TransactionsReceivedMetric, 'channel')
    outcome_data = query(TransactionsWithOutcomeMetric, 'outcome')

    data = call_data.merge!(trxn_data) { |_key, old, new| old.merge!(new) }
    data.merge!(outcome_data) { |_key, old, new| old.merge!(new) }
  end
end
