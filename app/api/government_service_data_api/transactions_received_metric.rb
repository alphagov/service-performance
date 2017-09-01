class GovernmentServiceDataAPI::TransactionsReceivedMetric
  include GovernmentServiceDataAPI::MetricStatus

  def self.build(data)
    data ||= {}

    new(
      total: data.fetch('total', NOT_APPLICABLE),
      online: data.fetch('online', NOT_APPLICABLE),
      phone: data.fetch('phone', NOT_APPLICABLE),
      paper: data.fetch('paper', NOT_APPLICABLE),
      face_to_face: data.fetch('face_to_face', NOT_APPLICABLE),
      other: data.fetch('other', NOT_APPLICABLE),
    )
  end

  def initialize(total: nil, online: nil, phone: nil, paper: nil, face_to_face: nil, other: nil)
    @total = total || NOT_PROVIDED
    @online = online || NOT_PROVIDED
    @phone = phone || NOT_PROVIDED
    @paper = paper || NOT_PROVIDED
    @face_to_face = face_to_face || NOT_PROVIDED
    @other = other || NOT_PROVIDED
  end

  attr_reader :total, :online, :phone, :paper, :face_to_face, :other

  def not_applicable?
    [
      @total, @online, @phone, @paper, @face_to_face, @other
    ].all? { |item| item == NOT_APPLICABLE }
  end

  def not_provided?
    [
      @total, @online, @phone, @paper, @face_to_face, @other
    ].all? { |item| item == NOT_PROVIDED }
  end

  def online_percentage
    return @online if @online.in? [NOT_PROVIDED, NOT_APPLICABLE]
    (@online.to_f / total) * 100
  end

  def phone_percentage
    return @phone if @phone.in? [NOT_PROVIDED, NOT_APPLICABLE]
    (@phone.to_f / total) * 100
  end

  def paper_percentage
    return @paper if @paper.in? [NOT_PROVIDED, NOT_APPLICABLE]
    (@paper.to_f / total) * 100
  end

  def face_to_face_percentage
    return @face_to_face if @face_to_face.in? [NOT_PROVIDED, NOT_APPLICABLE]
    (@face_to_face.to_f / total) * 100
  end

  def other_percentage
    return @other if @other.in? [NOT_PROVIDED, NOT_APPLICABLE]
    (@other.to_f / total) * 100
  end
end
