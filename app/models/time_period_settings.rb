require 'active_record/validations'

class TimePeriodSettings
  extend ActiveModel::Naming

  include ActiveRecord::Validations

  attr_accessor :range, :start_date_month, :start_date_year, :end_date_month, :end_date_year
  attr_accessor :errors

  def initialize(_params)
    @errors = ActiveModel::Errors.new(self)
    # Create an Errors object, which is required by validations and to use some view methods.
  end

  # Required method stubs
  def save; end

  def save!; end

  def new_record?
    false
  end

  def update_attribute; end

  # Validations
  validates_presence_of :start_date_month
end
