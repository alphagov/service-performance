require 'rails_helper'

RSpec.describe DeliveryOrganisation, type: :model do
  describe "validations" do
    subject(:delivery_organisation) { FactoryBot.build(:delivery_organisation) }

    it { should be_valid }

    it 'requires a natural_key' do
      delivery_organisation.natural_key = ''
      expect(delivery_organisation).to_not be_valid
    end

    it 'requires a name' do
      delivery_organisation.name = ''
      expect(delivery_organisation).to_not be_valid
    end

    it 'requires a website' do
      delivery_organisation.website = ''
      expect(delivery_organisation).to_not be_valid
    end
  end

  describe '#services' do
    it 'returns a scope of services, which belong to the delivery organisation' do
      delivery_organisation = FactoryBot.create(:delivery_organisation)
      service1 = FactoryBot.create(:service, delivery_organisation_id: delivery_organisation.id)
      service2 = FactoryBot.create(:service, delivery_organisation_id: delivery_organisation.id)

      expect(delivery_organisation.services.to_a).to match_array([service1, service2])
    end
  end
end
