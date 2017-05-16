class DepartmentSerializer < ActiveModel::Serializer
  attributes :natural_key, :name, :hostname
  attributes :agencies_count, :services_count

  def agencies_count
    object.agencies.count
  end

  def services_count
    object.services.count
  end
end
