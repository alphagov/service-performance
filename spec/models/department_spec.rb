require 'rails_helper'

RSpec.describe Department, type: :model do
  describe "validations" do
    subject(:department) { FactoryGirl.build(:department) }

    it { should be_valid }

    it 'requires a natural_key' do
      department.natural_key = ''
      expect(department).to fail_strict_validations
    end

    it 'requires a name' do
      department.name = ''
      expect(department).to fail_strict_validations
    end

    it 'requires a hostname' do
      department.hostname = ''
      expect(department).to fail_strict_validations
    end
  end
end
