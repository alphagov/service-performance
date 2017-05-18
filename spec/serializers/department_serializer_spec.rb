require 'rails_helper'

RSpec.describe DepartmentSerializer, type: :serializer do
  let(:department) { FactoryGirl.create(:department) }
  subject(:serializer) { DepartmentSerializer.new(department) }

  describe '#agencies_count' do
    it 'includes the number of agencies that belong to it' do
      FactoryGirl.create(:agency, department: department)

      attributes = serializer.attributes
      expect(attributes[:agencies_count]).to eq(1)
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
