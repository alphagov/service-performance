class Service < ApplicationRecord
  belongs_to :delivery_organisation, primary_key: :id, foreign_key: :delivery_organisation_id
  has_one :department, through: :delivery_organisation

  has_many :metrics, class_name: 'MonthlyServiceMetrics'

  validates_presence_of :natural_key
  validates_presence_of :name

  before_create do
    self.publish_token ||= SecureRandom.hex(64)
  end

  def services
    Service.where(id: self)
  end

  def to_param
    natural_key
  end
end
