require "administrate/base_dashboard"

class ServiceDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    department: Field::HasOne,
    delivery_organisation: Field::BelongsTo,
    purpose: Field::Text,
    how_it_works: Field::Text,
    typical_users: Field::Text,
    frequency_used: Field::Text,
    duration_until_outcome: Field::Text,
    start_page_url: Field::String,
    paper_form_url: Field::String,
    online_transactions_applicable: ApplicableMetricField,
    phone_transactions_applicable: ApplicableMetricField,
    paper_transactions_applicable: ApplicableMetricField,
    face_to_face_transactions_applicable: ApplicableMetricField,
    other_transactions_applicable: ApplicableMetricField,
    transactions_with_outcome_applicable: ApplicableMetricField,
    transactions_with_intended_outcome_applicable: ApplicableMetricField,
    calls_received_applicable: ApplicableMetricField,
    calls_received_get_information_applicable: ApplicableMetricField,
    calls_received_chase_progress_applicable: ApplicableMetricField,
    calls_received_challenge_decision_applicable: ApplicableMetricField,
    calls_received_other_applicable: ApplicableMetricField,
    calls_received_perform_transaction_applicable: ApplicableMetricField,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    name
    department
    delivery_organisation
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    name
    department
    delivery_organisation
    purpose
    how_it_works
    typical_users
    frequency_used
    duration_until_outcome
    start_page_url
    paper_form_url
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    name
    delivery_organisation
    purpose
    how_it_works
    typical_users
    frequency_used
    duration_until_outcome
    start_page_url
    paper_form_url
    online_transactions_applicable
    phone_transactions_applicable
    paper_transactions_applicable
    face_to_face_transactions_applicable
    other_transactions_applicable
    transactions_with_outcome_applicable
    transactions_with_intended_outcome_applicable
    calls_received_applicable
    calls_received_get_information_applicable
    calls_received_chase_progress_applicable
    calls_received_challenge_decision_applicable
    calls_received_other_applicable
    calls_received_perform_transaction_applicable
  ].freeze

  def display_resource(service)
    service.name
  end
end
