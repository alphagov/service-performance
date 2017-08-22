require 'rails_helper'

RSpec.describe GovernmentOrganisationRegister::Organisation do
  describe 'parsing end date' do
    def data(end_date:)
      {
        'key' => 'D001',
        'item' => [{
          'name' => 'Org',
          'website' => 'http://example.com',
          'end-date' => end_date
        }]
      }
    end

    it 'parses year-month-day' do
      organisation = GovernmentOrganisationRegister::Organisation.new(data(end_date: '2017-07-26'))
      expect(organisation.end_date).to eq(Date.new(2017, 7, 26))
    end

    it 'parses year-month' do
      organisation = GovernmentOrganisationRegister::Organisation.new(data(end_date: '2017-07'))
      expect(organisation.end_date).to eq(Date.new(2017, 7, 1))
    end

    it 'parses year' do
      organisation = GovernmentOrganisationRegister::Organisation.new(data(end_date: '2017'))
      expect(organisation.end_date).to eq(Date.new(2017, 1, 1))
    end

    it 'raises ArgumentError, with invalid date' do
      expect {
        GovernmentOrganisationRegister::Organisation.new(data(end_date: 'junk'))
      }.to raise_error(ArgumentError, "unexpected date format: 'junk'")
    end
  end
end
