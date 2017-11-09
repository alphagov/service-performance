require 'rails_helper'

RSpec.describe YearMonth, type: :model do
  describe '#initialize' do
    it 'can be initialized with Numeric arguments' do
      month = YearMonth.new(2017, 9)
      expect(month.year).to eq(2017)
      expect(month.month).to eq(9)
    end

    it 'can be initialized with String arguments' do
      month = YearMonth.new('2017', '09')
      expect(month.year).to eq(2017)
      expect(month.month).to eq(9)
    end

    it "raises ArgumentError if it's invalid" do
      expect { YearMonth.new(nil, nil) }.to raise_error(ArgumentError)
      expect { YearMonth.new(2017, 0) }.to raise_error(ArgumentError)
      expect { YearMonth.new(2017, 13) }.to raise_error(ArgumentError)
    end
  end

  specify 'equality' do
    expect(YearMonth.new(2017, 9)).to eq(YearMonth.new(2017, 9))
    expect(YearMonth.new(2017, 8)).to_not eq(YearMonth.new(2017, 9))
    expect(YearMonth.new(2017, 9)).to_not eq(YearMonth.new(2017, 8))
  end

  specify '#to_formatted_s' do
    month = YearMonth.new(2017, 9)
    expect(month.to_formatted_s).to eq('1 to 30 September 2017')
  end

  specify '#next' do
    month = YearMonth.new(2017, 9)
    expect(month.next).to eq(YearMonth.new(2017, 10))

    month = YearMonth.new(2017, 12)
    expect(month.next).to eq(YearMonth.new(2018, 1))
  end
end
