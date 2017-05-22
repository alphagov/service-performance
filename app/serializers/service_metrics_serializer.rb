class ServiceMetricsSerializer < ActiveModel::Serializer
  has_one :department
  has_one :service

  has_many :metrics
end
