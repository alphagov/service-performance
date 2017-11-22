class Completeness
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

  def complete?
    actual == expected
  end

  def incomplete?
    !complete?
  end
end
