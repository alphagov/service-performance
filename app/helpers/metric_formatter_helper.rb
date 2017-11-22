module MetricFormatterHelper
  def metric_to_human(value)
    text = number_to_human(value, precision: 3, significant: true, units: { thousand: 'k', million: 'm', billion: 'b' }, format: '%n%u')
    content_tag(:data, text, value: value)
  end

  def metric_to_percentage(value)
    return number_to_percentage(0, precision: 1) if value.nan?
    number_to_percentage(value, precision: 1)
  end
end
