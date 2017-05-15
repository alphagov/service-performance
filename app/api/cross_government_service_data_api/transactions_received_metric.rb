class CrossGovernmentServiceDataAPI::TransactionsReceivedMetric
  def self.build(data)
    new(
      total: data['total'],
      online: data['online'],
      phone: data['phone'],
      paper: data['paper'],
      face_to_face: data['face_to_face'],
      other: data['other'],
    )
  end

  def initialize(total: nil, online: nil, phone: nil, paper: nil, face_to_face: nil, other: nil)
    @total = total || 0
    @online = online || 0
    @phone = phone || 0
    @paper = paper || 0
    @face_to_face = face_to_face || 0
    @other = other || 0
  end

  def total
    @total
  end

  def online_percentage
    (@online.to_f / total) * 100
  end

  def phone_percentage
    (@phone.to_f / total) * 100
  end

  def paper_percentage
    (@paper.to_f / total) * 100
  end

  def face_to_face_percentage
    (@face_to_face.to_f / total) * 100
  end

  def other_percentage
    (@other.to_f / total) * 100
  end
end
