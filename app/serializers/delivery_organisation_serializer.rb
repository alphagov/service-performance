class DeliveryOrganisationSerializer < ActiveModel::Serializer
  attributes :type, :natural_key, :name, :hostname
  attributes :services_count

  def type
    'delivery-organisation'
  end

  def services_count
    object.services.count
  end
end
