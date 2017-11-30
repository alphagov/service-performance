class Service < ApplicationRecord
  belongs_to :owner, primary_key: :id, foreign_key: :owner_id, class_name: "User", optional: true
  belongs_to :delivery_organisation, primary_key: :id, foreign_key: :delivery_organisation_id
  has_one :department, through: :delivery_organisation

  has_many :metrics, class_name: 'MonthlyServiceMetrics'

  validates_presence_of :natural_key
  validates_presence_of :name

  before_create do
    self.publish_token ||= SecureRandom.hex(64)
  end

  def self.with_published_metrics
    self.joins(:metrics).where(monthly_service_metrics: { published: true }).distinct
  end

  def to_param
    natural_key
  end
end
