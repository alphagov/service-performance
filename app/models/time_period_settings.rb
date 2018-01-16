require 'active_record/validations'

class TimePeriodSettings
  extend ActiveModel::Naming

  include ActiveRecord::Validations

  attr_accessor :range, :start_date_month, :start_date_year, :end_date_month, :end_date_year
  attr_accessor :errors

  def initialize(params)
    @errors = ActiveModel::Errors.new(self)
    @range = params[:range]
    @start_date_month = params[:start_date_month]
    @start_date_year = params[:start_date_year]
    @end_date_month = params[:end_date_month]
    @end_date_year = params[:end_date_year]
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
  validates_presence_of :range, :start_date_month
end
