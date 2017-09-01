class AggregatedCallsReceivedMetric
  alias :read_attribute_for_serialization :send

  def initialize(organisation, time_period)
    @organisation = organisation
    @time_period = time_period

    @sampled = metrics.any?(&:sampled)

    defaults = Hash.new(Metric::NOT_APPLICABLE)
    defaults['sampled-total'] = 0
    @totals = metrics.group_by(&:item).each.with_object(defaults) do |(item, metrics), memo|
      quantity = begin
        if metrics.any?(&:quantity)
          metrics.sum { |metric| metric.quantity || 0 }
        else
          Metric::NOT_PROVIDED
        end
      end

      memo[item] = quantity

      if item == 'total'
        memo['sampled-total'] = begin
          if metrics.any? { |metric| metric.sample_size || metric.quantity }
            metrics.sum { |metric| metric.sample_size || metric.quantity || 0 }
          else
            Metric::NOT_PROVIDED
          end
        end
      end
    end
  end

  def total
    @totals['total']
  end

  def get_information
    @totals['get-information']
  end

  def chase_progress
    @totals['chase-progress']
  end

  def challenge_a_decision
    @totals['challenge-a-decision']
  end

  def other
    @totals['other']
  end

  def sampled_total
    @totals['sampled-total']
  end

  attr_reader :sampled

private

  attr_reader :organisation, :time_period

  def metrics
    @metrics ||= CallsReceivedMetric
      .where(service_code: organisation.services.pluck(:natural_key))
      .where('starts_on >= ? AND ends_on <= ?', time_period.starts_on, time_period.ends_on)
  end
end
