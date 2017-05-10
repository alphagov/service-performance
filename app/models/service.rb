class Service < ApplicationRecord
  belongs_to :department, primary_key: :natural_key, foreign_key: :department_code, optional: true
  belongs_to :agency, primary_key: :natural_key, foreign_key: :agency_code, optional: true

  validates_presence_of :natural_key, strict: true
  validates_presence_of :name, strict: true
  validates_presence_of :hostname, strict: true
  validates_presence_of :department, strict: true
end
