require 'rails_helper'

RSpec.describe RawMetrics, type: :model do
  let(:keys) {
    ["online", "phone", "paper", "face_to_face", "channel-other"]
  }
  let(:table) {
    [
      [[0, 0, 0, 0, 0],         0],
      [[10, 10, 10, 10, 10],   50],
      [[10, 10],               20],
      [[],                      0],
      [[10, nil, 10, nil, 10], 30],
    ]
  }

  describe '#raw_metrics' do
    it 'complains when used without a subclass' do
      r = RawMetrics.new
      expect { r.send(:query) }.to raise_error(NotImplementedError)
    end

    it 'can calculate trxn_received totals' do
      r = RawMetrics.new

      table.each { |input_row, expected_result|
        params = keys.zip(input_row).to_h
        total = r.send(:calculate_trxn_total, params)
        expect(total).to eq(expected_result)
      }
    end
  end
end
