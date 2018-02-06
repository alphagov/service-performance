require 'rails_helper'

RSpec.describe TimePeriod, type: :model do
  describe '.default' do
    subject(:period) do
      Timecop.freeze(2017, 5, 12) do
        TimePeriod.default
      end
    end

    it 'starts on 12 months before the end date' do
      expect(period.starts_on).to eq(Date.parse('2016-04-01'))
    end

    it 'ends on the end of the month 2 months ago' do
      expect(period.ends_on).to eq(Date.parse('2017-03-31'))
    end
  end

  describe '#start_month' do
    it 'returns a YearMonth representing the start date' do
      period = TimePeriod.new(Date.new(2017, 10, 1), Date.new(2017, 11, 30))
      expect(period.start_month).to eq(YearMonth.new(2017, 10))
    end
  end

  describe '#end_month' do
    it 'returns a YearMonth representing the end date' do
      period = TimePeriod.new(Date.new(2017, 10, 1), Date.new(2017, 11, 30))
      expect(period.end_month).to eq(YearMonth.new(2017, 11))
    end
  end

  describe '#duration' do
    it 'correctly returns the duration for a valid time period' do
      period = TimePeriod.new(Date.new(2017, 10, 1), Date.new(2017, 11, 30))
      expect(period.months_covered).to eq(2)
    end
  end

  describe '#serialise' do
    it 'can serialise objects' do
      period = TimePeriod.new(Date.new(2017, 1, 1), Date.new(2017, 3, 30))
      serialised = TimePeriod.serialise(period)
      expect(serialised).to eq("2017-01-01 2017-03-30")
    end
  end

  describe '#deserialise' do
    it 'can deserialise objects' do
      period = TimePeriod.new(Date.new(2017, 1, 1), Date.new(2017, 3, 30))
      new_period = TimePeriod.deserialise("2017-01-01 2017-03-30")
      expect(period.starts_on).to eq(new_period.starts_on)
      expect(period.ends_on).to eq(new_period.ends_on)
    end

    it 'can ignore bad input data when deserialising' do
      period = TimePeriod.deserialise("Not dates")
      expect(period).to be_nil
    end
  end

  describe 'serialisation roundtrip' do
    it 'can serialise and deserialise objects' do
      period = TimePeriod.new(Date.new(2017, 1, 1), Date.new(2017, 3, 30))
      serialised = TimePeriod.serialise(period)
      new_period = TimePeriod.deserialise(serialised)
      expect(period.starts_on).to eq(new_period.starts_on)
      expect(period.ends_on).to eq(new_period.ends_on)
    end
  end


  describe '#previous_period' do
    it 'can return the previous period for short periods' do
      period = TimePeriod.new(Date.new(2017, 1, 1), Date.new(2017, 3, 30))
      new_period = period.previous_period
      expect(new_period.months_covered).to eq(period.months_covered)
      expect(new_period.starts_on.month).to eq(1)
      expect(new_period.starts_on.year).to eq(period.starts_on.year - 1)
      expect(new_period.ends_on.month).to eq(3)
      expect(new_period.ends_on.year).to eq(period.ends_on.year - 1)
    end

    it 'can return the previous period for periods that wrap across a year' do
      period = TimePeriod.new(Date.new(2016, 10, 1), Date.new(2017, 3, 30))
      new_period = period.previous_period
      expect(new_period.months_covered).to eq(period.months_covered)
      expect(new_period.starts_on.month).to eq(10)
      expect(new_period.starts_on.year).to eq(period.starts_on.year - 1)
      expect(new_period.ends_on.month).to eq(3)
      expect(new_period.ends_on.year).to eq(period.ends_on.year - 1)
    end
  end
end
