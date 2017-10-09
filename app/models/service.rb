class Service < ApplicationRecord
  belongs_to :department, primary_key: :natural_key, foreign_key: :department_code, optional: true
  belongs_to :delivery_organisation, primary_key: :natural_key, foreign_key: :delivery_organisation_code, optional: true

  has_many :metrics, class_name: 'MonthlyServiceMetrics'

  validates_presence_of :natural_key, strict: true
  validates_presence_of :name, strict: true
  validates_presence_of :hostname, strict: true
  validates_presence_of :department, strict: true

  before_create do
    self.publish_token ||= SecureRandom.hex(64)
  end

  def services
    Service.where(id: self)
  end
end
