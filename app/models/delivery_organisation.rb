class DeliveryOrganisation < ApplicationRecord
  belongs_to :department, primary_key: :id, foreign_key: :department_id, optional: true
  has_many :services, primary_key: :id, foreign_key: :delivery_organisation_id

  has_many :metrics, through: :services

  validates_presence_of :natural_key
  validates_uniqueness_of :natural_key
  validates_presence_of :name
  validates_presence_of :website

  def to_param
    natural_key
  end

  def services_count
    services.count
  end
end
