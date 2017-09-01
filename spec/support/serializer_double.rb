module SerializableDouble
  def serializable_double(doubled_class, *args)
    instance_double(doubled_class, *args).tap do |double|
      allow(double).to receive(:read_attribute_for_serialization, &double.method(:send))
    end
  end
end

RSpec.configure do |config|
  config.include(SerializableDouble, type: :serializer)
end
