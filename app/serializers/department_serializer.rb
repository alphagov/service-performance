class DepartmentSerializer < ActiveModel::Serializer
  attributes :type, :natural_key, :name, :hostname
  attributes :delivery_organisations_count, :services_count

  def type
    'department'
  end

  def delivery_organisations_count
    object.delivery_organisations.count
  end

  def services_count
    object.services.count
  end
end