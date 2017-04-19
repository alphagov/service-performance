class ServiceSerializer < ActiveModel::Serializer
  attributes :natural_key, :natural_name, :hostname
end
