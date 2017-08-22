class GovernmentSerializer < ActiveModel::Serializer
  attributes :type, :departments_count, :delivery_organisations_count,
             :services_count

  def type
    'government'
  end
end
