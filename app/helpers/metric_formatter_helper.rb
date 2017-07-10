module MetricFormatterHelper

  def metric_to_human(value)
    text = number_to_human(value, precision: 2, significant: true, units: {thousand: 'k', million: 'm', billion: 'b'}, format: '%n%u')
    content_tag(:data, text, value: value)
  end

  def metric_to_percentage(value)
    number_to_percentage(value, precision: 0)
  end

end
