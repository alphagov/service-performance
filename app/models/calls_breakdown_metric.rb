class CallsBreakdownMetric < ApplicationRecord
  belongs_to :department, primary_key: :natural_key, foreign_key: :department_code, optional: true
  belongs_to :agency, primary_key: :natural_key, foreign_key: :agency_code, optional: true
  belongs_to :service, primary_key: :natural_key, foreign_key: :service_code, optional: true

  validates_presence_of :department, strict: true
  validates_presence_of :service, strict: true
  validates_presence_of :starts_on, strict: true
  validates_presence_of :ends_on, strict: true

  validates_presence_of :quantity, strict: true
  validates_presence_of :reason, strict: true
  validates_inclusion_of :sampled, in: [true, false], strict: true
end
