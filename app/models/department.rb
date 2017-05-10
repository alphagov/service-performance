class Department < ApplicationRecord
  validates_presence_of :natural_key, strict: true
  validates_presence_of :name, strict: true
  validates_presence_of :hostname, strict: true
end
