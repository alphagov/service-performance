module TimePeriodHelper
  def start_date_string
    start_date.strftime "%e %b %Y"
  end

  def end_date_string
    end_date.strftime "%e %b %Y"
  end

  def start_date
    @data.time_period.starts_on
  end

  def end_date
    @data.time_period.ends_on
  end
end
