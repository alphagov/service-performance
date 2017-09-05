class TimePeriod
  DEFAULT_TIME_PERIOD_DURATION = 6.months
  DEFAULT_TIME_PERIOD_LAG = 2.months

  def self.default
    ends_on = Date.new(2017, 6, 30)  # (Date.today - DEFAULT_TIME_PERIOD_LAG).end_of_month
    starts_on = Date.new(2017, 1, 1) # (ends_on - DEFAULT_TIME_PERIOD_DURATION + 1.day)

    new(starts_on, ends_on)
  end

  def initialize(starts_on, ends_on)
    @starts_on = starts_on
    @ends_on = ends_on
  end

  def months
    (@ends_on.year * 12 + @ends_on.month) - (@starts_on.year * 12 + @starts_on.month) + 1
  end

  attr_reader :starts_on, :ends_on
end
