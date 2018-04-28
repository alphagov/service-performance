require 'rails_helper'

RSpec.describe Department, type: :model do
  describe "validations" do
    subject(:department) { FactoryBot.build(:department) }

    it { should be_valid }

    it 'requires a natural_key' do
      department.natural_key = ''
      expect(department).to fail_strict_validations
    end

    it 'requires a name' do
      department.name = ''
      expect(department).to fail_strict_validations
    end

    it 'requires a website' do
      department.website = ''
      expect(department).to fail_strict_validations
    end
  end

  describe '#services' do
    it 'returns a scope of services, which belong to the department' do
      department = FactoryBot.create(:department)
      delivery_organisation = FactoryBot.create(:delivery_organisation, department: department)
      service1 = FactoryBot.create(:service, delivery_organisation: delivery_organisation)
      service2 = FactoryBot.create(:service, delivery_organisation: delivery_organisation)

      expect(department.services.to_a).to match_array([service1, service2])
    end
  end
end
