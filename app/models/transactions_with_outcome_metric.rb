class TransactionsWithOutcomeMetric < ApplicationRecord
  belongs_to :department, primary_key: :natural_key, foreign_key: :department_code, optional: true
  belongs_to :delivery_organisation, primary_key: :natural_key, foreign_key: :delivery_organisation_code, optional: true
  belongs_to :service, primary_key: :natural_key, foreign_key: :service_code, optional: true

  validates_presence_of :department, strict: true
  validates_presence_of :service, strict: true
  validates_presence_of :starts_on, strict: true
  validates_presence_of :ends_on, strict: true

  validates_presence_of :outcome, strict: true
end
