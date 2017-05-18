class DepartmentMetricsSerializer < ActiveModel::Serializer
  has_one :department

  has_many :metrics
end
