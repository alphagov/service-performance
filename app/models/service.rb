class Service < ApplicationRecord
  has_paper_trail

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

  def required_metrics
    %i[online_transactions_applicable
       phone_transactions_applicable
       paper_transactions_applicable
       face_to_face_transactions_applicable
       other_transactions_applicable
       transactions_processed_applicable
       transactions_processed_with_intended_outcome_applicable
       calls_received_applicable
       calls_received_get_information_applicable
       calls_received_chase_progress_applicable
       calls_received_challenge_decision_applicable
       calls_received_other_applicable
       calls_received_perform_transaction_applicable].inject([]) do |memo, m|
      memo << m.to_s.sub!('_applicable', '').to_sym if self.send(m) == true
      memo
    end
  end

  def to_param
    natural_key
  end
end
