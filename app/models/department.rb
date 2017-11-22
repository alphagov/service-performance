class Department < ApplicationRecord
  has_many :delivery_organisations, primary_key: :id, foreign_key: :department_id
  has_many :services, through: :delivery_organisations

  has_many :metrics, through: :services

  validates_presence_of :natural_key, strict: true
  validates_presence_of :name, strict: true
  validates_presence_of :website, strict: true

  def to_param
    natural_key
  end

  def delivery_organisations_count
    delivery_organisations.count
  end

  def services_count
    services.count
  end
end
