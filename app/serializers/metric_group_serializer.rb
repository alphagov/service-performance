class MetricGroupSerializer < ActiveModel::Serializer
  has_one :entity
  has_many :metrics
end
