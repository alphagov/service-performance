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
end
