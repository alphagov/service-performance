module MetricSerializer
  def metric(name)
    value = ->(serializer) { serializer.object.read_attribute_for_serialization(name) }
    applicable = ->(serializer) { value.(serializer) != Metric::NOT_APPLICABLE }

    attribute name, if: applicable do
      result = value.(self)
      if result == Metric::NOT_PROVIDED
        nil
      else
        result
      end
    end
  end

  def metrics(*names)
    names.each { |name| metric(name) }
  end
end
