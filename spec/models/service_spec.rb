require 'rails_helper'

RSpec.describe Service, type: :model do
  describe "validations" do
    subject(:service) { FactoryGirl.build(:service) }

    it { should be_valid }

    it 'requires a natural_key' do
      service.natural_key = ''
      expect(service).to fail_strict_validations
    end

    it 'requires a name' do
      service.name = ''
      expect(service).to fail_strict_validations
    end

    it 'requires a hostname' do
      service.hostname = ''
      expect(service).to fail_strict_validations
    end

    it "references a valid department" do
      service.department = nil
      expect(service).to fail_strict_validations
    end
  end
end
