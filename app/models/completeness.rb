class Completeness
  def initialize(actual:, expected:, months_expected:)
    @actual = actual
    @expected = expected
    @months_expected = months_expected
  end

  attr_reader :actual, :expected, :months_expected

  def +(other)
    actual = self.actual + other.actual
    expected = self.expected + other.expected
    months = self.months_expected + other.months_expected
    self.class.new(actual: actual, expected: expected, months_expected: months)
  end

  def complete?
    actual == expected
  end

  def months_complete?
    actual == months_expected
  end

  def incomplete?
    !complete?
  end
end
