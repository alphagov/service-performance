class Service < ApplicationRecord
  belongs_to :department, primary_key: :natural_key, foreign_key: :department_code, optional: true
  belongs_to :delivery_organisation, primary_key: :natural_key, foreign_key: :delivery_organisation_code, optional: true

  validates_presence_of :natural_key, strict: true
  validates_presence_of :name, strict: true
  validates_presence_of :hostname, strict: true
  validates_presence_of :department, strict: true

  def services
    Service.where(id: self)
  end
end
