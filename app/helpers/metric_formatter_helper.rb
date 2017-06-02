module MetricFormatterHelper

  def metric_to_human(value)
    number_to_human(value, precision: 2, significant: true, units: {thousand: 'k', million: 'm', billion: 'b'}, format: '%n%u')
  end

  def metric_to_percentage(value)
    number_to_percentage(value, precision: 0)
  end

end
