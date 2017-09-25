module TimePeriodHelper
  DEFAULT_TIME_PERIOD_DURATION = 12.months
  DEFAULT_TIME_PERIOD_LAG = 2.months

  def start_date_string
    start_date.strftime "%e %b %Y"
  end

  def end_date_string
    end_date.strftime "%e %b %Y"
  end

  def start_date
    (end_date - DEFAULT_TIME_PERIOD_DURATION + 1.day)
  end

  def end_date
    (Date.today - DEFAULT_TIME_PERIOD_LAG).end_of_month
  end
end
