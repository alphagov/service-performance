require "administrate/base_dashboard"

class ServiceDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    natural_key: Field::String,
    name: Field::String,
    department: Field::HasOne,
    delivery_organisation: Field::BelongsTo.with_options(primary_key: :natural_key, foreign_key: :delivery_organisation_code),
    hostname: Field::String,
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
    published: Field::Boolean
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    name
    department
    delivery_organisation
  ].freeze

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

  FORM_ATTRIBUTES = %i[
    natural_key
    name
    delivery_organisation
    hostname
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
