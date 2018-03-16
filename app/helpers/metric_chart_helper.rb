module MetricChartHelper
  def calculate_transaction_difference(current_metrics, previous_metrics, total_label)
    @current_metrics = current_metrics
    @previous_metrics = previous_metrics
    if increased?
      "#{@current_metrics.sum - @previous_metrics.sum} (#{ difference_increase_percentage } %) more #{total_label.gsub("Total transactions", "transactions").downcase} than previous #{@previous_metrics.count} months".html_safe
    elsif same_difference
      "Same number of #{total_label.gsub("Total transactions", "transactions").downcase} as previous #{@previous_metrics.count} months".html_safe
    else
      "#{@previous_metrics.sum - @current_metrics.sum} (#{ difference_decrease_percentage } %) less #{total_label.gsub("Total transactions", "transactions").downcase} than previous #{@previous_metrics.count} months".html_safe
    end
  end

  def set_li_arrow_direction(current_metrics, previous_metrics)
    @current_metrics = current_metrics
    @previous_metrics = previous_metrics
    return nil if same_difference
    if increased?
      "increase"
    else
      "decrease"
    end
  end

  private

  def same_difference
    true if @current_metrics.sum == @previous_metrics.sum
  end

  def increased?
    return nil if same_difference
    if @current_metrics.sum > @previous_metrics.sum
      true
    else
      false
    end
  end

  def difference_increase_percentage
    difference = @current_metrics.sum.to_f - @previous_metrics.sum.to_f
    percentage = difference / @current_metrics.sum.to_f * 100
    percentage.round(2)
  end

  def difference_decrease_percentage
    difference = @previous_metrics.sum.to_f - @current_metrics.sum.to_f
    percentage = difference / @previous_metrics.sum.to_f * 100
    percentage.round(2)
  end
end
