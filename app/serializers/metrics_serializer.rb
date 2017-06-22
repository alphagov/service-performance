class MetricsSerializer < ActiveModel::Serializer
  attribute :group

  has_many :metric_groups

  def group
    object.group.to_s
  end
end
