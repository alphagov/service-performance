class TransactionsReceivedMetric
  alias :read_attribute_for_serialization :send

  def self.to_proc
    ->(metrics) { from_metrics(metrics) }
  end

  def self.from_metrics(metrics)
    service = metrics.service

    metric = ->(value, applicable:) do
      if value
        value
      else
        if applicable
          Metric::NOT_PROVIDED
        else
          Metric::NOT_APPLICABLE
        end
      end
    end

    new(
      online: metric.(metrics.online_transactions, applicable: service.online_transactions_applicable?),
      phone: metric.(metrics.phone_transactions, applicable: service.phone_transactions_applicable?),
      paper: metric.(metrics.paper_transactions, applicable: service.paper_transactions_applicable?),
      face_to_face: metric.(metrics.face_to_face_transactions, applicable: service.face_to_face_transactions_applicable?),
      other: metric.(metrics.other_transactions, applicable: service.other_transactions_applicable?),
    )
  end

  def initialize(online:, phone:, paper:, face_to_face:, other:)
    @online = online
    @phone = phone
    @paper = paper
    @face_to_face = face_to_face
    @other = other
  end

  attr_reader :online, :phone, :paper, :face_to_face, :other

  def applicable?
    [online, phone, paper, face_to_face, other].any? { |value| value != Metric::NOT_APPLICABLE }
  end

  def total
    sum = ->(a, b) do
      values = Set[a, b]
      case values
      when Set[Metric::NOT_APPLICABLE, Metric::NOT_APPLICABLE]
        Metric::NOT_APPLICABLE
      when Set[Metric::NOT_PROVIDED, Metric::NOT_PROVIDED]
        Metric::NOT_PROVIDED
      when Set[Metric::NOT_APPLICABLE, Metric::NOT_PROVIDED]
        Metric::NOT_PROVIDED
      else
        values.reject { |value| value.in?([Metric::NOT_APPLICABLE, Metric::NOT_PROVIDED]) }.reduce(:+)
      end
    end

    [online, phone, paper, face_to_face, other].reduce(&sum)
  end

  def completeness
    Completeness.new
  end

  def +(other)
    # TODO: test this
    sum = ->(a, b) do
      values = Set[a, b]
      case values
      when Set[Metric::NOT_APPLICABLE, Metric::NOT_APPLICABLE]
        Metric::NOT_APPLICABLE
      when Set[Metric::NOT_PROVIDED, Metric::NOT_PROVIDED]
        Metric::NOT_PROVIDED
      when Set[Metric::NOT_APPLICABLE, Metric::NOT_PROVIDED]
        Metric::NOT_PROVIDED
      else
        values.reject { |value| value.in?([Metric::NOT_APPLICABLE, Metric::NOT_PROVIDED]) }.reduce(:+)
      end
    end

    self.class.new(
      online: sum.(self.online, other.online),
      phone: sum.(self.phone, other.phone),
      paper: sum.(self.paper, other.paper),
      face_to_face: sum.(self.face_to_face, other.face_to_face),
      other: sum.(self.other, other.other),
    )
  end
end
