class GovernmentSerializer < ActiveModel::Serializer
  attributes :departments_count, :delivery_organisations_count, :services_count
end
