class AggregatedTransactionsReceivedMetric
  alias :read_attribute_for_serialization :send

  def initialize(organisation, time_period)
    @totals = TransactionsReceivedMetric
      .where(service_code: organisation.services.pluck(:natural_key))
      .where('starts_on >= ? AND ends_on <= ?', time_period.starts_on, time_period.ends_on)
      .each.with_object({}) do |metric, memo|
        memo[metric.channel] ||= 0
        memo[metric.channel] += metric.quantity
      end
  end

  def is_applicable?
    @totals.size.positive?
  end

  def total
    [online, phone, paper, face_to_face, other].compact.sum
  end

  def online
    @totals['online']
  end

  def phone
    @totals['phone']
  end

  def paper
    @totals['paper']
  end

  def face_to_face
    @totals['face_to_face']
  end

  def other
    @totals['other']
  end
end
