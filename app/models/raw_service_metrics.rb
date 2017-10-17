class RawServiceMetrics < RawMetrics
  def initialize(root, time_period:)
    @root = root
    @time_period = time_period
  end

  attr_reader :root, :time_period

private

  def query(cls, key)
    metrics = cls
      .where(service_code: root.natural_key)
      .where('starts_on >= ? AND ends_on <= ?', time_period.starts_on, time_period.ends_on)

    data = Hash.new { |h, k|
      h[k] = {
        "department" => @root.department.name,
        "agency" => @root.delivery_organisation.name,
        "service" => @root.name
      }
    }

    results = metrics.inject(data) { |h, (metric, _v)|
      keyname = clean_keyname(metric, key)
      h[metric['starts_on']][keyname] = metric['quantity']
      h
    }

    results.reduce({}) { |h, (k, v)|
      h[k] = [v]
      h
    }
  end
end
