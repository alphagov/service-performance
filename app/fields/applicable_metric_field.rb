require "administrate/field/base"

class ApplicableMetricField < Administrate::Field::Base
  def to_s
    data
  end
end
