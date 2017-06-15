require 'rails_helper'

RSpec.describe DepartmentSerializer, type: :serializer do
  let(:department) { FactoryGirl.create(:department) }
  subject(:serializer) { DepartmentSerializer.new(department) }

  describe '#delivery_organisations_count' do
    it 'includes the number of delivery organisations that belong to it' do
      FactoryGirl.create(:delivery_organisation, department: department)

      attributes = serializer.attributes
      expect(attributes[:delivery_organisations_count]).to eq(1)
    end
  end

  describe '#services_count' do
    it 'includes the number of services that belong to it' do
      FactoryGirl.create(:service, department: department)

      attributes = serializer.attributes
      expect(attributes[:services_count]).to eq(1)
    end
  end
end
