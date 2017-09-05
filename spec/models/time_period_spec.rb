require 'rails_helper'

RSpec.describe TimePeriod, type: :model do
  describe '.default' do
    subject(:period) do
      Timecop.freeze(2017, 5, 12) do
        TimePeriod.default
      end
    end

    it 'starts on 6 months before the end date' do
      expect(period.starts_on).to eq(Date.parse('2017-01-01'))
    end

    it 'ends on the end of the month' do
      expect(period.ends_on).to eq(Date.parse('2017-06-30'))
    end

    it 'is exactly 6 months apart' do
      expect(period.months).to eq(6)
    end
  end
end
