class Department < ApplicationRecord
  has_many :delivery_organisations, primary_key: :natural_key, foreign_key: :department_code
  has_many :services, through: :delivery_organisations

  has_many :metrics, through: :services

  validates_presence_of :natural_key, strict: true
  validates_presence_of :name, strict: true
  validates_presence_of :website, strict: true
end
