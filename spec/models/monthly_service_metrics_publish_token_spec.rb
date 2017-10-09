require 'rails_helper'

RSpec.describe MonthlyServiceMetricsPublishToken, type: :model do
  describe '.valid?' do
    let(:month) { instance_double(YearMonth) }
    let(:service) { instance_double(Service, publish_token: 'ea8546acb283f48c8bf051f8b3fffa76de789523b6ffc4cae5944283e7768d5259b6daf8a770ce0f359b190963eea6ad5fefaeabc7e51bbfadc1753aa29334ee') }
    let(:metrics) { instance_double(MonthlyServiceMetrics, month: month, service: service) }

    it 'raises ArgumentError when MonthlyServiceMetrics#service not set' do
      expect {
        allow(metrics).to receive(:service) { nil }
        MonthlyServiceMetricsPublishToken.valid?(token: 'token', metrics: metrics)
      }.to raise_error(ArgumentError, 'MonthlyServiceMetrics#service must be set')
    end

    it 'raises ArgumentError when MonthlyServiceMetrics#month not set' do
      expect {
        allow(metrics).to receive(:month) { nil }
        MonthlyServiceMetricsPublishToken.valid?(token: 'token', metrics: metrics)
      }.to raise_error(ArgumentError, 'MonthlyServiceMetrics#month must be set')
    end

    it 'is falsey when token not set' do
      expect(MonthlyServiceMetricsPublishToken.valid?(token: nil, metrics: metrics)).to be_falsey
    end

    it 'is truthy with a valid token' do
      allow(month).to receive_messages(year: 2017, month: 6)
      token = MonthlyServiceMetricsPublishToken.generate(service: service, month: month)
      expect(MonthlyServiceMetricsPublishToken.valid?(token: token, metrics: metrics)).to be_truthy
    end

    it 'is falsey with an invalid token' do
      token = 'junk'
      expect(MonthlyServiceMetricsPublishToken.valid?(token: token, metrics: metrics)).to be_falsey
    end

    it 'is falsey with a token for another month' do
      allow(month).to receive_messages(year: 2017, month: 6)

      token = MonthlyServiceMetricsPublishToken.generate(service: service, month: instance_double(YearMonth, year: 2017, month: 12))
      expect(MonthlyServiceMetricsPublishToken.valid?(token: token, metrics: metrics)).to be_falsey
    end
  end

  describe '.generate' do
    let(:month) { instance_double(YearMonth, year: 2017, month: 6) }
    let(:service) { instance_double(Service, publish_token: 'ea8546acb283f48c8bf051f8b3fffa76de789523b6ffc4cae5944283e7768d5259b6daf8a770ce0f359b190963eea6ad5fefaeabc7e51bbfadc1753aa29334ee') }

    it 'returns a token, encoding the month & year' do
      token = MonthlyServiceMetricsPublishToken.generate(service: service, month: month)

      verifier = ActiveSupport::MessageVerifier.new(service.publish_token)
      payload = verifier.verify(token)
      expect(payload[:year]).to eq(2017)
      expect(payload[:month]).to eq(6)
    end
  end
end
