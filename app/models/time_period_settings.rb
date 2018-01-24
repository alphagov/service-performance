require 'active_record/validations'

class TimePeriodSettings
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :range, :start_date_month, :start_date_year, :end_date_month, :end_date_year, :next
  attr_accessor :errors

  def errors
    @errors ||= ActiveModel::Errors.new(self)
  end

  def validate_months
    valid_range = /^(0?[1-9]|1[012])$/
    unless start_date_month.match?(valid_range)
      errors.add(:start_date_month, "must be between 1 - 12")
    end

    unless end_date_month.match?(valid_range)
      errors.add(:end_date_month, "must be between 1 - 12")
    end
  end

  def validate_years
    unless start_date_year.match?(/^\d{4}$/)
      errors.add(:start_date_year, "format should be YYYY")
    end

    unless end_date_year.match?(/^\d{4}$/)
      errors.add(:end_date_year, "format should be YYYY")
    end

    unless start_date_year.match?(/^(19|20)\d{2}$/)
      errors.add(:start_date_year, "must be after 1900")
    end
  end

  def validate_date
    start_date_string = start_date_month + "-" + start_date_year
    end_date_string = end_date_month + "-" + end_date_year

    begin
      start_date = DateTime.strptime(start_date_string, '%m-%Y')
      end_date = DateTime.strptime(end_date_string, '%m-%Y')
    rescue
      return
    end

    # We can't choose a time period before we have any data
    if start_date < TimePeriod.earliest_data_date.starts_on
      errors.add(:start_date_month, "start date cannot be before #{first_data_date}")
    end

    if end_date > DateTime.now
      errors.add(:end_date_year, "end date can't be in the future")
    end

    if end_date < start_date
      errors.add(:end_date_year, "end date can't be before start date")
    end
  end

  validates_presence_of :start_date_month, :start_date_year, :end_date_month, :end_date_year, unless: lambda { self.range != "custom" }
  validates_presence_of :range, unless: lambda { self.range == "custom" }
  validate :validate_months, unless: lambda { self.range != "custom" }
  validate :validate_years, unless: lambda { self.range != "custom" }
  validate :validate_date, unless: lambda { self.range != "custom" }
end
