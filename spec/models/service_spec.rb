require 'rails_helper'

RSpec.describe Service, type: :model do
  describe "validations" do
    subject(:service) { FactoryBot.build(:service) }

    it { should be_valid }

    it 'requires a natural_key' do
      service.natural_key = ''
      expect(service).to_not be_valid
    end

    it 'requires a name' do
      service.name = ''
      expect(service).to_not be_valid
    end
  end

  it 'can determine if metrics are not applicable' do
    service = FactoryBot.build(:service)
    applicable = service.metric_applicable?(:online_transactions)
    expect(applicable).to eq(true)
  end

  it 'can determine if metrics are applicable' do
    service = FactoryBot.build(:service, online_transactions_applicable: false)
    applicable = service.metric_applicable?(:online_transactions)
    expect(applicable).to eq(false)
  end

  it 'generates a publish token, when created' do
    service = FactoryBot.build(:service)
    expect {
      service.save
    }.to change(service, :publish_token)

    expect(service.publish_token.size).to eq(128)
  end
end
