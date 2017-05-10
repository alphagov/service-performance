class MetricSerializer < ActiveModel::Serializer
  def attributes(requested_attrs = nil, reload = false)
    object.attributes.reverse_merge(type: object.type)
  end
end
