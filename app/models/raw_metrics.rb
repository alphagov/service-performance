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
    ["Department", "Agency", "Service", "Timestamp", "Transactions Received - Total"].freeze + MAPPING.keys
  end

  def data
    return to_enum(:data) unless block_given?

    yield header_row.to_csv

    raw_metrics.each { |date, list_of_hash|
      list_of_hash.flatten.each { |hash|
        row = [hash['department'], hash['agency'], hash['service'], date]
        row << calculate_trxn_total(hash)

        MAPPING.each { |_key, val|
          row << (hash.fetch(val, 'N/A') || 'N/P')
        }
        yield row.to_csv
      }
    }
  end

private

  def calculate_trxn_total(hash)
    ["online", "phone", "paper", "face_to_face", "channel-other"].reduce(0) { |acc, item|
      val = hash.fetch(item, false)
      if val.is_a? Integer
        acc + val
      else
        acc
      end
    }
  end

  def query
    raise NotImplementedError, "must be implemented by sub-classes"
  end

  def clean_keyname(h, key)
    if h[key] == 'other'
      "#{key}-other"
    else
      h[key]
    end
  end

  def raw_metrics
    call_data = query(CallsReceivedMetric, 'item')
    trxn_data = query(TransactionsReceivedMetric, 'channel')
    outcome_data = query(TransactionsWithOutcomeMetric, 'outcome')

    data = call_data.merge!(trxn_data) { |_, old, new|
      old | new
    }
    data = data.merge!(outcome_data) { |_, old, new|
      old | new
    }

    results = Hash.new { |h, k| h[k] = [] }
    data.each { |date, list|
      items = list.group_by { |h| h["service"] }
      items.values.each { |value|
        results[date] << value.reduce({}, :merge)
      }
    }
    results
  end
end
