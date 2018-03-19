module MetricChartHelper
  def calculate_transaction_difference(current_metrics, previous_metrics, total_label)
    @current_metrics = current_metrics.sum
    @previous_metrics = previous_metrics.sum
    if increased?
      "#{humanize_metric(@current_metrics - @previous_metrics)} (#{difference_increase_percentage} %) more #{total_label.gsub('Total transactions', 'transactions').downcase} than previous #{previous_metrics.count} months".html_safe
    elsif same_difference
      "Same number of #{total_label.gsub('Total transactions', 'transactions').downcase} as previous #{previous_metrics.count} months".html_safe
    else
      "#{humanize_metric(@previous_metrics - @current_metrics)} (#{difference_decrease_percentage} %) less #{total_label.gsub('Total transactions', 'transactions').downcase} than previous #{previous_metrics.count} months".html_safe
    end
  end

  def set_li_arrow_direction(current_metrics, previous_metrics)
    @current_metrics = current_metrics.sum
    @previous_metrics = previous_metrics.sum
    return nil if same_difference
    if increased?
      "increase"
    else
      "decrease"
    end
  end

private

  def humanize_metric(value)
    number_to_human(value, precision: 3, significant: true, units: { thousand: 'k', million: 'm', billion: 'b' }, format: '%n%u')
  end

  def same_difference
    true if @current_metrics == @previous_metrics
  end

  def increased?
    return nil if same_difference
    if @current_metrics > @previous_metrics
      true
    else
      false
    end
  end

  def difference_increase_percentage
    difference = @current_metrics.to_f - @previous_metrics.to_f
    percentage = difference / @current_metrics.to_f * 100
    percentage.round(2)
  end

  def difference_decrease_percentage
    difference = @previous_metrics.to_f - @current_metrics.to_f
    percentage = difference / @previous_metrics.to_f * 100
    percentage.round(2)
  end
end
