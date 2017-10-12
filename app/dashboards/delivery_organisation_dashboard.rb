require "administrate/base_dashboard"

class DeliveryOrganisationDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    natural_key: Field::String,
    name: Field::String,
    website: Field::String,
    department: Field::BelongsTo.with_options(primary_key: :natural_key, foreign_key: :department_code),
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
    natural_key
    name
    department
    website
  ].freeze

  def display_resource(delivery_organisation)
    delivery_organisation.name
  end
end
