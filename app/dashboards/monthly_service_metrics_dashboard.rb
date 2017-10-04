require "administrate/base_dashboard"

class MonthlyServiceMetricsDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.

  ATTRIBUTE_TYPES = {
    department: Field::HasOne,
    delivery_organisation: Field::HasOne,
    service: Field::BelongsTo,
    month: YearMonthField,
    online_transactions: MetricField,
    phone_transactions: MetricField,
    paper_transactions: MetricField,
    face_to_face_transactions: MetricField,
    other_transactions: MetricField,
    transactions_with_outcome: MetricField,
    transactions_with_intended_outcome: MetricField,
    calls_received: MetricField,
    calls_received_get_information: MetricField,
    calls_received_chase_progress: MetricField,
    calls_received_challenge_decision: MetricField,
    calls_received_other: MetricField,
    calls_received_perform_transaction: MetricField,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    department
    delivery_organisation
    service
    month
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    service
    month
    online_transactions
    phone_transactions
    paper_transactions
    face_to_face_transactions
    other_transactions
    transactions_with_outcome
    transactions_with_intended_outcome
    calls_received
    calls_received_get_information
    calls_received_chase_progress
    calls_received_challenge_decision
    calls_received_other
    calls_received_perform_transaction
  ].freeze
end
