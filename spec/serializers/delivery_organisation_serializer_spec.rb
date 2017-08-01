require 'rails_helper'

RSpec.describe DeliveryOrganisationSerializer, type: :serializer do
  let(:delivery_organisation) { FactoryGirl.create(:delivery_organisation) }
  subject(:serializer) { DeliveryOrganisationSerializer.new(delivery_organisation) }

  it 'serializes a delivery organisation' do
    expect {
      serializer.to_json
    }.to_not raise_error
  end

  describe '#services_count' do
    it 'includes the number of services that belong to it' do
      FactoryGirl.create(:service, delivery_organisation: delivery_organisation)

      attributes = serializer.attributes
      expect(attributes[:services_count]).to eq(1)
    end
  end
end
