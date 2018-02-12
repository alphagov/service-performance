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

  def as_percentage
    pct = (@actual.to_f / @expected.to_f) * 100
    pct = 0 if pct.nan?
    pct.round(2)
  end

  def complete?
    actual == expected
  end

  def incomplete?
    !complete?
  end
end
