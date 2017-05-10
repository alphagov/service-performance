class Metric

  def self.type(type)
    @type = type
  end

  def self.attribute(attribute)
    @attributes ||= []
    @attributes << attribute

    define_method(attribute) do
      @attributes[attribute]
    end
  end

  def self.attributes
    @attributes
  end

  def initialize(attributes = {})
    missing_keywords = self.class.attributes - attributes.keys
    if missing_keywords.any?
      keywords = missing_keywords.size == 1 ? 'keyword' : 'keywords'
      raise ArgumentError, "missing #{keywords}: #{missing_keywords.join(', ')}"
    end

    unknown_keywords = attributes.keys - self.class.attributes
    if unknown_keywords.any?
      keywords = unknown_keywords.size == 1 ? 'keyword' : 'keywords'
      raise ArgumentError, "unknown #{keywords}: #{unknown_keywords.join(', ')}"
    end

    @attributes = attributes
  end

  attr_reader :attributes

  def type
    self.class.instance_variable_get('@type')
  end
end
