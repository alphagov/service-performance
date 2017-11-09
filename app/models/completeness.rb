class Completeness
  def self.multiplier(obj)
    return 1 if obj === Service
    obj.services.count
  end

  def initialize(actual:, expected:)
    @actual = actual
    @expected = expected
  end

  attr_reader :actual, :expected

  def +(other)
    actual = self.actual + other.actual
    expected = self.expected + other.expected
    self.class.new(actual: actual, expected: expected)
  end
end
