require 'rails_helper'

RSpec.describe ServiceSerializer, type: :serializer do
  let(:service) { FactoryGirl.create(:service) }
  subject(:serializer) { ServiceSerializer.new(service) }

  it 'serializes a service' do
    expect {
      serializer.to_json
    }.to_not raise_error
  end
end
