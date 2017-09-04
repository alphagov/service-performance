class AggregatedCallsReceivedMetric
  alias :read_attribute_for_serialization :send

  def initialize(organisation, time_period, expected_multiplier = 1)
    @organisation = organisation
    @time_period = time_period
    @completeness = {}

    @sampled = metrics.any?(&:sampled)

    defaults = Hash.new(Metric::NOT_APPLICABLE)
    defaults['sampled-total'] = 0
    @channels = metrics.group_by(&:item).each.with_object(defaults) do |(item, metrics), memo|
      quantity = begin
        if metrics.any?(&:quantity)
          metrics.sum { |metric| metric.quantity || 0 }
        else
          Metric::NOT_PROVIDED
        end
      end

      @completeness[item] = {
        actual: metrics.count { |m| !m.quantity.in?([Metric::NOT_PROVIDED, nil]) },
        expected: 12 * expected_multiplier
      }
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

  def applicable?
    @channels.any?
  end

  def total
    @channels['total']
  end

  def get_information
    @channels['get-information']
  end

  def chase_progress
    @channels['chase-progress']
  end

  def challenge_a_decision
    @channels['challenge-a-decision']
  end

  def other
    @channels['other']
  end

  def sampled_total
    @channels['sampled-total']
  end

  attr_reader :sampled
  attr_accessor :completeness

private

  attr_reader :organisation, :time_period

  def metrics
    @metrics ||= CallsReceivedMetric
      .where(service_code: organisation.services.pluck(:natural_key))
      .where('starts_on >= ? AND ends_on <= ?', time_period.starts_on, time_period.ends_on)
  end
end
