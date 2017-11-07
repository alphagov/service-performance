class Metric
  NOT_APPLICABLE = :not_applicable
  NOT_PROVIDED = :not_provided

  class Definition
    Item = Struct.new(:name, :from, :applicable)

    def initialize(definition)
      @items = []
      instance_eval(&definition)
    end

    attr_reader :items

    def item(name, from:, applicable:)
      @items << Item.new(name.to_sym, from, applicable)
    end
  end

  def self.define(&definition)
    @definition = Definition.new(definition)
    attr_reader *self.definition.items.map(&:name)
  end

  def self.definition
    @definition
  end

  # Initializes a metric, taking values for each of the defined items.
  #
  # These values should either be a Numeric value, `Metric::NOT_PROVIDED` or
  # `Metric::NOT_APPLICABLE`.
  #
  # It mimics Ruby's handling of keyword arguments.
  def initialize(items = {})
    missing_arguments = self.class.definition.items.map(&:name).reject { |name| items.has_key?(name) }
    if missing_arguments.any?
      raise ArgumentError, "missing keywords: #{missing_arguments.join(', ')}"
    end

    self.class.definition.items.each do |item|
      value = items.fetch(item.name)
      instance_variable_set("@#{item.name}", value)
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
        value = if item.applicable.(metrics)
          NOT_PROVIDED
        else
          NOT_APPLICABLE
        end
      end

      memo[item.name] = value
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

  alias :read_attribute_for_serialization :send

  def applicable?
    !values.all? { |value| value == NOT_APPLICABLE }
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
    end

    self.class.new(items)
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
    values = Set[a, b]
    case values
    when Set[Metric::NOT_APPLICABLE, Metric::NOT_APPLICABLE]
      Metric::NOT_APPLICABLE
    when Set[Metric::NOT_PROVIDED, Metric::NOT_PROVIDED]
      Metric::NOT_PROVIDED
    when Set[Metric::NOT_APPLICABLE, Metric::NOT_PROVIDED]
      Metric::NOT_PROVIDED
    else
      values.reject { |value| value.in?([Metric::NOT_APPLICABLE, Metric::NOT_PROVIDED]) }.reduce(:+)
    end
  end
end

class TransactionsReceivedMetric < Metric
  define do
    item :online, from: ->(metrics) { metrics.online_transactions}, applicable: ->(metrics) { metrics.service.online_transactions_applicable? }
    item :phone, from: ->(metrics) { metrics.phone_transactions}, applicable: ->(metrics) { metrics.service.phone_transactions_applicable? }
    item :paper, from: ->(metrics) { metrics.paper_transactions}, applicable: ->(metrics) { metrics.service.paper_transactions_applicable? }
    item :face_to_face, from: ->(metrics) { metrics.face_to_face_transactions}, applicable: ->(metrics) { metrics.service.face_to_face_transactions_applicable? }
    item :other, from: ->(metrics) { metrics.other_transactions}, applicable: ->(metrics) { metrics.service.other_transactions_applicable? }
  end

  def total
    values.reduce(&method(:sum))
  end

  def completeness
    Completeness.new
  end
end
