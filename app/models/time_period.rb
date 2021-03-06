class TimePeriod
  DEFAULT_TIME_PERIOD_DURATION = 12
  DEFAULT_TIME_PERIOD_LAG = 2

  def self.default
    from_number_previous_months(DEFAULT_TIME_PERIOD_DURATION)
  end

  def self.from_number_previous_months(months)
    ends_on = most_recent_data
    starts_on = (ends_on - months.months + 1.day)

    new(starts_on, ends_on)
  end

  def self.earliest_data_date
    MonthlyServiceMetrics.order("month asc").first.month
  end

  def self.most_recent_data
    (Date.today - DEFAULT_TIME_PERIOD_LAG.months).end_of_month
  end

  # Convert the object into a string that contains all of the
  # information
  def self.serialise(period)
    "#{period.starts_on} #{period.ends_on}"
  end

  # Converts the provided string into a TimePeriod, but requires
  # that the string was generated with self.serialise
  def self.deserialise(input)
    begin
      starts, ends = input.split
      TimePeriod.new(
        Date.parse(starts),
        Date.parse(ends)
      )
    rescue
      nil
    end
  end

  def initialize(starts_on, ends_on)
    @starts_on = starts_on
    @ends_on = ends_on
  end

  def months
    start_month..end_month
  end

  def months_as_short_names
    months.to_a.map { |m|
      m.starts_on.to_formatted_s(:month)
    }
  end

  attr_reader :starts_on, :ends_on

  def start_month
    YearMonth.new(starts_on.year, starts_on.month)
  end

  def end_month
    YearMonth.new(ends_on.year, ends_on.month)
  end

  def range_label
    "#{start_month.to_formatted_s(:month_and_year)} to #{end_month.to_formatted_s(:month_and_year)}"
  end

  # Obtain the number of months that this date range covers.
  def months_covered
    (@ends_on.year * 12 + @ends_on.month) - (@starts_on.year * 12 + @starts_on.month) + 1
  end

  # Retrieve the time period that precedes the current period.
  # This time period should match the month range so if current period is
  # Jan-Mar 2017 the previous period is Jan-Mar 2016. If current period is
  # Oct 2016 - Feb 2017 then the previous period is Oct 2015 - Feb 2016.
  def previous_period
    TimePeriod.new(
      @starts_on.dup.advance(months: -12),
      @ends_on.dup.advance(months: -12)
    )
  end

  # Defines equality as the start and end dates being the same
  def ==(o)
    o.class == self.class && o.starts_on == @starts_on && o.ends_on == @ends_on
  end
end
