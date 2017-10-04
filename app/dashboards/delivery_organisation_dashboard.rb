require "administrate/base_dashboard"

class DeliveryOrganisationDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    name
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    name
  ].freeze

  FORM_ATTRIBUTES = %i[
    name
  ].freeze

  def display_resource(delivery_organisation)
    delivery_organisation.name
  end
end
