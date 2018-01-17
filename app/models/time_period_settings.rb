require 'active_record/validations'

class TimePeriodSettings
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :range, :start_date_month, :start_date_year, :end_date_month, :end_date_year, :next
  attr_accessor :errors

  def errors
    @errors ||= ActiveModel::Errors.new(self)
  end

  # Validations
  validates_presence_of :start_date_month
end
