require 'rails_helper'

RSpec.describe Agency, type: :model do
  describe "validations" do
    subject(:agency) { FactoryGirl.build(:agency) }

    it { should be_valid }

    it 'requires a natural_key' do
      agency.natural_key = ''
      expect(agency).to fail_strict_validations
    end

    it 'requires a name' do
      agency.name = ''
      expect(agency).to fail_strict_validations
    end

    it 'requires a hostname' do
      agency.hostname = ''
      expect(agency).to fail_strict_validations
    end

    it "references a valid department" do
      agency.department = nil
      expect(agency).to fail_strict_validations
    end
  end
end
