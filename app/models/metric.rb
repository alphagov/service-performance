class Metric
  NOT_APPLICABLE = :not_applicable
  NOT_PROVIDED = :not_provided

  class Definition
    Item = Struct.new(:name, :from, :applicable)

    def initialize(definition)
      @items = []
      instance_eval(&definition)
    end

    attr_reader :items, :denominator_method

    def item(name, from:, applicable:)
      @items << Item.new(name.to_sym, from, applicable)
    end

    def percentage_of(denominator_method)
      @denominator_method = denominator_method
    end

    def denominator_method?
      @denominator_method ? true : false
    end

    def item_attribute_names
      items.map(&:name)
    end

    def item_completeness_attribute_names
      items.map { |item| :"#{item.name}_completeness" }
    end
  end

  class << self
    def define(&definition)
      @definition = Definition.new(definition)

      attr_reader(*self.definition.item_attribute_names)
      attr_reader(*self.definition.item_completeness_attribute_names)
    end

    attr_reader :definition
  end

  # Initializes a metric, taking values for each of the defined items.
  #
  # These values should either be a Numeric value, `Metric::NOT_PROVIDED` or
  # `Metric::NOT_APPLICABLE`.
  #
  # It mimics Ruby's handling of keyword arguments.
  def initialize(items = {})
    required_attributes = self.class.definition.item_attribute_names + self.class.definition.item_completeness_attribute_names
    missing_arguments = required_attributes.reject { |name| items.has_key?(name) }
    if missing_arguments.any?
      raise ArgumentError, "missing keywords: #{missing_arguments.join(', ')}"
    end

    self.class.definition.items.each do |item|
      value = items.fetch(item.name)
      instance_variable_set("@#{item.name}", value)

      completeness = items.fetch(:"#{item.name}_completeness")
      instance_variable_set("@#{item.name}_completeness", completeness)
    end

    if self.class.definition.denominator_method?
      self.class.definition.items.each do |item|
        self.class.send(:define_method, "#{item.name}_percentage") do
          numerator = send(item.name)
          return numerator if numerator.in?([NOT_APPLICABLE, NOT_PROVIDED])

          denominator = send(self.class.definition.denominator_method)
          return denominator if denominator.in?([NOT_APPLICABLE, NOT_PROVIDED])

          (numerator.to_f / denominator.to_f) * 100
        end
      end
    end
  end

  # Intializes a metric from a `MonthlyServiceMetric`.
  #
  # The value is first extracted using proc defined by the `from` proc defined
  # on the item.
  #
  # If the value is nil, it next checks to see whether that item is applicable
  # using the `applicable` proc defined on the item. If the item isn't
  # applicable then the value is set to `NOT_APPLICABLE`, otherwise it's set as
  # `NOT_PROVIDED`
  def self.from_metrics(metrics)
    items = definition.items.each.with_object({}) do |item, memo|
      value = item.from.(metrics)

      unless value
        value =
          if item.applicable.(metrics)
            NOT_PROVIDED
          else
            NOT_APPLICABLE
          end
      end

      memo[item.name] = value

      completeness =
        case value
        when NOT_APPLICABLE
          Completeness.new(actual: 0, expected: 0)
        when NOT_PROVIDED
          Completeness.new(actual: 0, expected: 1)
        else
          Completeness.new(actual: 1, expected: 1)
        end
      memo[:"#{item.name}_completeness"] = completeness
    end

    new(items)
  end

  # Returns a proc which instantiates a Metric subclass from a
  # MonthlyServiceMetric.
  #
  #     class CustomMetric < Metric
  #       ...
  #     end
  #
  #.    metrics.map(&CustomMetric)
  def self.to_proc
    ->(metrics) { from_metrics(metrics) }
  end

  def not_applicable?
    values.all? { |value| value == NOT_APPLICABLE }
  end

  def not_provided?
    return false if not_applicable?

    values.all? { |value| value.in?([NOT_APPLICABLE, NOT_PROVIDED]) }
  end

  # Adds two metics together.
  #
  # There're a couple of special cases.
  #  * when two metric items are `NOT_APPLICABLE`, then the result is `NOT_APPLICABLE`
  #  * when two metric items are `NOT_PROVIDED`, then the result is `NOT_PROVIDED`
  #  * when one metric item is `NOT_APPLICABLE` and the other is `NOT_PROVIDED` then
  #    the `NOT_PROVIDED` value takes precedence, and is returned.
  def +(other)
    items = self.class.definition.items.each.with_object({}) do |item, memo|
      value = sum(self.send(item.name), other.send(item.name))
      memo[item.name] = value

      completeness_attribute_name = :"#{item.name}_completeness"
      completeness = self.send(completeness_attribute_name) + other.send(completeness_attribute_name)
      memo[completeness_attribute_name] = completeness
    end

    self.class.new(items)
  end

  def completeness
    self.class.definition.items.each.with_object({}) do |item, memo|
      memo[item.name] = self.send(:"#{item.name}_completeness")
    end
  end

private

  # Returns the values of all of the items defined on this metric.
  #
  # It accesses the values using the reader method for that item.
  def values
    self.class.definition.items.map { |item| send(item.name) }
  end

  # Sum two item values.
  #
  # See: #+
  def sum(a, b)
    if a == Metric::NOT_APPLICABLE && b == Metric::NOT_APPLICABLE
      Metric::NOT_APPLICABLE
    elsif a == Metric::NOT_PROVIDED && b == Metric::NOT_PROVIDED
      Metric::NOT_PROVIDED
    elsif (a == Metric::NOT_APPLICABLE && b == Metric::NOT_PROVIDED) || (a == Metric::NOT_PROVIDED && b == Metric::NOT_APPLICABLE)
      Metric::NOT_PROVIDED
    else
      [a, b].reject { |value| value.in?([Metric::NOT_APPLICABLE, Metric::NOT_PROVIDED]) }.reduce(:+)
    end
  end
end
