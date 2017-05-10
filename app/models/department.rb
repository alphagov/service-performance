class Department < ApplicationRecord
  has_many :agencies, primary_key: :natural_key, foreign_key: :department_code

  validates_presence_of :natural_key, strict: true
  validates_presence_of :name, strict: true
  validates_presence_of :hostname, strict: true
end
