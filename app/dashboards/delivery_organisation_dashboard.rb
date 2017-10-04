require "administrate/base_dashboard"

class DeliveryOrganisationDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    department: Field::BelongsTo,
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    name
    department
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    name
    department
  ].freeze

  FORM_ATTRIBUTES = %i[
    name
    department
  ].freeze

  def display_resource(delivery_organisation)
    delivery_organisation.name
  end
end
