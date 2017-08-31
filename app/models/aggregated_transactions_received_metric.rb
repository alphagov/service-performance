class AggregatedTransactionsReceivedMetric
  alias :read_attribute_for_serialization :send

  def initialize(organisation, time_period)
    @channels = TransactionsReceivedMetric
      .where(service_code: organisation.services.pluck(:natural_key))
      .where('starts_on >= ? AND ends_on <= ?', time_period.starts_on, time_period.ends_on)
      .each.with_object({}) do |metric, memo|
        if metric.quantity.present?
          memo[metric.channel] ||= 0
          memo[metric.channel] += metric.quantity
        end
      end
  end

  def applicable?
    @channels.any?
  end

  def total
    [online, phone, paper, face_to_face, other].compact.sum
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
end
