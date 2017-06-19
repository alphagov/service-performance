require 'rails_helper'

RSpec.describe Government, type: :model do
  subject(:government) { Government.new }

  describe '#departments_count' do
    it 'returns the total number of departments' do
      FactoryGirl.create_list(:department, 3)

      expect(government.departments_count).to eq(3)
    end
  end

  describe '#delivery_organisations_count' do
    it 'returns the total number of departments' do
      FactoryGirl.create_list(:delivery_organisation, 2)

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
