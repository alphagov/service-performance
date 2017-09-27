class YearMonth
  class Serializer < ActiveRecord::Type::Value
    def type
      :year_month
    end

    def cast(value)
      value
    end

    def serialize(value)
      value ? value.date : nil
    end

    def deserialize(value)
      case value
      when Date
        YearMonth.new(value.year, value.month)
      when String
        date = Date.parse(value)
        YearMonth.new(date.year, date.month)
      end
    end
  end

  def initialize(year, month)
    @year = year.to_i
    @month = month.to_i
    @date = Date.new(@year, @month)
  end

  attr_reader :year, :month, :date

  def ==(other)
    year == other.year && month == other.month
  end

  def to_formatted_s
    end_date = date.end_of_month
    "#{date.to_formatted_s(:day_excluding_leading_zero)} to #{end_date.to_formatted_s(:long_day_month_year)}"
  end
end
