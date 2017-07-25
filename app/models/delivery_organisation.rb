class DeliveryOrganisation < ApplicationRecord
  belongs_to :department, primary_key: :natural_key, foreign_key: :department_code, optional: true
  has_many :services, primary_key: :natural_key, foreign_key: :delivery_organisation_code

  validates_presence_of :natural_key, strict: true
  validates_presence_of :name, strict: true
  validates_presence_of :website, strict: true
  validates_presence_of :department, strict: true
end
