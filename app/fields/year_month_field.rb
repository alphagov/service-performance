require "administrate/field/base"

class YearMonthField < Administrate::Field::Base
  def to_s
    data.to_formatted_s(:long_month_year)
  end
end
