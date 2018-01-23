class Department < ApplicationRecord
  has_many :delivery_organisations, primary_key: :id, foreign_key: :department_id
  has_many :services, through: :delivery_organisations

  has_many :metrics, through: :services

  validates_presence_of :natural_key, strict: true
  validates_presence_of :name, strict: true
  validates_presence_of :website, strict: true

  def self.with_delivery_organisations
    # Only return departments where at least one of its services
    # contains a published metric.
    self.joins(:services).merge(Service.with_published_metrics).distinct
  end

  def to_param
    natural_key
  end

  def delivery_organisations_count
    delivery_organisations.with_services.count
  end

  def services_count
    services.with_published_metrics.count
  end
end
