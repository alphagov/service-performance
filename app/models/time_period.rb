class TimePeriod
  DEFAULT_TIME_PERIOD_DURATION = 12.months
  DEFAULT_TIME_PERIOD_LAG = 2.months

  def self.default
    ends_on = (Date.today - DEFAULT_TIME_PERIOD_LAG).end_of_month
    starts_on = (ends_on - DEFAULT_TIME_PERIOD_DURATION + 1.day)

    new(starts_on, ends_on)
  end

  def initialize(starts_on, ends_on)
    @starts_on = starts_on
    @ends_on = ends_on
  end

  def months
    start_month..end_month
  end

  attr_reader :starts_on, :ends_on

  def start_month
    YearMonth.new(starts_on.year, starts_on.month)
  end

  def end_month
    YearMonth.new(ends_on.year, ends_on.month)
  end

  # Obtain the duration between the start and end of the time period
  # in months. This is the number of months covered by the range.
  def duration
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
end
