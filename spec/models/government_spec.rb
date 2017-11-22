require 'rails_helper'

RSpec.describe Government, type: :model do
  subject(:government) { Government.new }

  describe '#departments_count' do
    it 'returns the total number of departments' do
      d1 = FactoryGirl.create(:department, name: "test 1")
      d2 = FactoryGirl.create(:department, name: "test 2")
      d3 = FactoryGirl.create(:department, name: "test 3")

      do1 = FactoryGirl.create(:delivery_organisation, name: "do test 1", department: d1)
      do2 = FactoryGirl.create(:delivery_organisation, name: "do test 2", department: d2)
      do3 = FactoryGirl.create(:delivery_organisation, name: "do test 3", department: d3)

      FactoryGirl.create(:service, name: "service test 1", delivery_organisation: do1)
      FactoryGirl.create(:service, name: "service test 2", delivery_organisation: do2)
      FactoryGirl.create(:service, name: "service test 3", delivery_organisation: do3)

      expect(government.departments_count).to eq(3)
    end
  end

  describe '#delivery_organisations_count' do
    it 'returns the total number of departments' do
      d1 = FactoryGirl.create(:department, name: "test 1")

      do1 = FactoryGirl.create(:delivery_organisation, name: "do test 1", department: d1)
      do2 = FactoryGirl.create(:delivery_organisation, name: "do test 2", department: d1)

      FactoryGirl.create(:service, name: "service test 1", delivery_organisation: do1)
      FactoryGirl.create(:service, name: "service test 2", delivery_organisation: do2)


      expect(government.delivery_organisations_count).to eq(2)
    end
  end

  describe '#services_count' do
    it 'returns the total number of services' do
      FactoryGirl.create_list(:service, 1)

      expect(government.services_count).to eq(1)
    end
  end
end
