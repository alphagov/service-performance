class Service < ApplicationRecord
  belongs_to :department, primary_key: :natural_key, foreign_key: :department_code
  belongs_to :delivery_organisation, primary_key: :natural_key, foreign_key: :delivery_organisation_code

  has_many :metrics, class_name: 'MonthlyServiceMetrics'

  validates_presence_of :natural_key
  validates_presence_of :name
  validates_presence_of :hostname

  before_create do
    self.publish_token ||= SecureRandom.hex(64)
  end

  def services
    Service.where(id: self)
  end
end
