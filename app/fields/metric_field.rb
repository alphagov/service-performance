require "administrate/field/base"

class MetricField < Administrate::Field::Base
  def to_s
    data.to_s
  end
end
