require 'rails_helper'

RSpec.describe Completeness, type: :model do
  describe '#initialize' do
    it 'initializes with actual and expected values' do
      completeness = Completeness.new(actual: 0, expected: 1)
      expect(completeness.actual).to eq(0)
      expect(completeness.expected).to eq(1)
    end
  end

  describe '#+ (addition)' do
    it 'sums the actual and expected values' do
      completeness1 = Completeness.new(actual: 0, expected: 1)
      completeness2 = Completeness.new(actual: 1, expected: 1)

      result = completeness1 + completeness2
      expect(result.actual).to eq(1)
      expect(result.expected).to eq(2)
    end
  end
end
