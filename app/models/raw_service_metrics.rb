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
      }}

    metrics.inject(data) { |h, (k, _v)|
      # We have 'other' in two different metrics...
      keyname = if k[key] == 'other'
                  "#{key}-other"
                else
                  k[key]
                end

      h[k['starts_on']][keyname] = k['quantity']
      h
    }
  end
end
