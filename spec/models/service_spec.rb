require 'rails_helper'

RSpec.describe Service, type: :model do
  describe 'validations' do
    subject(:service) { FactoryGirl.build(:service) }

    it 'has a valid factory' do
      expect(service).to be_valid
    end

    it 'requires a name' do
      service.name = ''
      expect(service).to_not be_valid
    end
  end
end
