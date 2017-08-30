class MetricsSerializer < ActiveModel::Serializer
  attribute :group_by

  has_many :totals
  has_many :metric_groups

  def group_by
    object.group_by.to_s
  end
end
