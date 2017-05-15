class DepartmentSerializer < ActiveModel::Serializer
  attributes :natural_key, :name, :hostname
end
