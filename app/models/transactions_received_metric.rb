class TransactionsReceivedMetric
  alias :read_attribute_for_serialization :send

  def self.to_proc
    ->(metrics) { new(metrics) }
  end

  def initialize(metrics)
    @metrics = metrics
    @service = metrics.service
  end

  def applicable?
    [online, phone, paper, face_to_face, other].any? { |value| value != Metric::NOT_APPLICABLE }
  end

  def total
    0
  end

  def online
    if metrics.online_transactions
      metrics.online_transactions
    else
      if service.online_transactions_applicable?
        Metric::NOT_PROVIDED
      else
        Metric::NOT_APPLICABLE
      end
    end
  end

  def phone
    if metrics.phone_transactions
      metrics.phone_transactions
    else
      if service.phone_transactions_applicable?
        Metric::NOT_PROVIDED
      else
        Metric::NOT_APPLICABLE
      end
    end
  end

  def paper
    if metrics.paper_transactions
      metrics.paper_transactions
    else
      if service.paper_transactions_applicable?
        Metric::NOT_PROVIDED
      else
        Metric::NOT_APPLICABLE
      end
    end
  end

  def face_to_face
    if metrics.face_to_face_transactions
      metrics.face_to_face_transactions
    else
      if service.face_to_face_transactions_applicable?
        Metric::NOT_PROVIDED
      else
        Metric::NOT_APPLICABLE
      end
    end
  end

  def other
    if metrics.other_transactions
      metrics.other_transactions
    else
      if service.other_transactions_applicable?
        Metric::NOT_PROVIDED
      else
        Metric::NOT_APPLICABLE
      end
    end
  end

  def completeness
    Completeness.new
  end

private

  attr_reader :metrics, :service
end
