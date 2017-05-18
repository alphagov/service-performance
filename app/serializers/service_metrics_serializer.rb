class ServiceMetricsSerializer < ActiveModel::Serializer
  has_one :service

  has_many :metrics
end
