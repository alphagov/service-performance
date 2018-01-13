class DeliveryOrganisation < ApplicationRecord
  include PgSearch

  belongs_to :department, primary_key: :id, foreign_key: :department_id, optional: true
  has_many :services, primary_key: :id, foreign_key: :delivery_organisation_id

  validates_presence_of :natural_key
  validates_uniqueness_of :natural_key
  validates_presence_of :name
  validates_presence_of :website

  has_many :metrics, through: :services

  pg_search_scope :search, against: %i(name acronym)

  def self.with_services
    self.joins(:metrics).where(monthly_service_metrics: { published: true }).distinct
  end

  def metrics_search(search_term, _groupby)
    if search_term
      services = Service.search(search_term).where(delivery_organisation: self)
      return MonthlyServiceMetrics.where(service_id: services.map(&:id))
    end
    metrics
  end

  def to_param
    natural_key
  end

  def services_count
    services.with_published_metrics.count
  end
end
