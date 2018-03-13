module MetricChartHelper
  def calculate_transaction_difference(current_metrics, previous_metrics, total_label)
    if current_metrics.sum > previous_metrics.sum
      "#{current_metrics.sum - previous_metrics.sum} (#{ difference_increase_percentage(current_metrics.sum, previous_metrics.sum) } %) more #{total_label.gsub("Total transactions", "transactions").downcase} than previous #{previous_metrics.count} months".html_safe
    elsif current_metrics.sum == previous_metrics.sum
      "Same number of #{total_label.gsub("Total transactions", "transactions").downcase} as previous #{previous_metrics.count} months".html_safe
    else
      "#{previous_metrics.sum - current_metrics.sum} (#{ difference_decrease_percentage(current_metrics.sum, previous_metrics.sum) })less #{total_label.gsub("Total transactions", "transactions").downcase} than previous #{previous_metrics.count} months".html_safe
    end
  end

  def difference_increase_percentage(current_metrics_sum, previous_metrics_sum)
    difference = current_metrics_sum.to_f - previous_metrics_sum.to_f
    percentage = difference / current_metrics_sum.to_f * 100
    percentage.round(2)
  end

  def difference_decrease_percentage(current_metrics_sum, previous_metrics_sum)
    difference = previous_metrics_sum.to_f - current_metrics_sum.to_f
    percentage = difference / previous_metrics_sum.to_f * 100
    percentage.round(2)
  end
end
