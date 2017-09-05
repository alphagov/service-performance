class AggregatedTransactionsReceivedMetric
  alias :read_attribute_for_serialization :send

  def initialize(organisation, time_period)
    @organisation = organisation
    @time_period = time_period
    @completeness = {}

    expected_multiplier = Completeness.multiplier(@organisation)

    defaults = Hash.new(Metric::NOT_APPLICABLE)
    @channels = metrics.group_by(&:channel).each.with_object(defaults) do |(channel, metrics), memo|
      quantity = begin
        if metrics.any?(&:quantity)
          metrics.sum { |metric| metric.quantity || 0 }
        else
          Metric::NOT_PROVIDED
        end
      end

      @completeness[channel] = {
        actual: metrics.count { |m| !m.quantity.in?([Metric::NOT_PROVIDED, nil]) },
        expected: @time_period.months * expected_multiplier
      }

      memo[channel] = quantity
    end
  end

  def applicable?
    @channels.any?
  end

  def total
    metrics = [online, phone, paper, face_to_face, other].reject { |item| item.in?([Metric::NOT_APPLICABLE, Metric::NOT_PROVIDED]) }
    if metrics.any?
      metrics.sum
    else
      Metric::NOT_APPLICABLE
    end
  end

  def online
    @channels['online']
  end

  def phone
    @channels['phone']
  end

  def paper
    @channels['paper']
  end

  def face_to_face
    @channels['face_to_face']
  end

  def other
    @channels['other']
  end

  attr_reader :completeness

private

  attr_reader :organisation, :time_period

  def metrics
    TransactionsReceivedMetric
      .where(service_code: organisation.services.pluck(:natural_key))
      .where('starts_on >= ? AND ends_on <= ?', time_period.starts_on, time_period.ends_on)
  end
end
