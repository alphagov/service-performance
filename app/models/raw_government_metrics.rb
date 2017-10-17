class RawGovernmentMetrics < RawMetrics
  def initialize(time_period:)
    @time_period = time_period
  end

  attr_reader :time_period

private

  def query(cls, key)
    service_ids = Hash[Service.all.map { |s|
      [s.natural_key, [s.name, s.department.name, s.delivery_organisation.name]]
    }]

    metrics = cls
      .where('starts_on >= ? AND ends_on <= ?', time_period.starts_on, time_period.ends_on)
      .order('starts_on')
      .group_by { |m| [m.service_code, m.delivery_organisation_code, m.starts_on] }

    results = Hash.new { |h, k| h[k] = [] }

    metrics.each { |(service_code, _, date), list|
      merged_metric = list.inject({}) { |memo, metric|
        keyname = clean_keyname(metric, key)
        memo[keyname] = metric["quantity"]
        memo
      }

      merged_metric["department"] = service_ids[service_code][1]
      merged_metric["agency"] = service_ids[service_code][2]
      merged_metric["service"] = service_ids[service_code][0]

      results[date] << merged_metric
    }
    results
  end
end
