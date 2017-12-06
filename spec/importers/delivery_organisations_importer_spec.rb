require 'rails_helper'

RSpec.describe DeliveryOrganisationsImporter, type: :importer do
  subject(:importer) { DeliveryOrganisationsImporter.new }

  describe '#import' do
    let(:output) { StringIO.new }
    let(:acronyms) { StringIO.new }

    let(:organisation) { instance_double(GovernmentOrganisationRegister::Organisation, retired?: false) }
    let(:organisations) { instance_double(GovernmentOrganisationRegister::Organisations) }

    before do
      allow(GovernmentOrganisationRegister::Organisations).to receive(:new) { organisations }
      allow(organisations).to receive(:each).and_yield(organisation)
    end

    describe 'new organisation' do
      it 'imports the organisation' do
        allow(organisation).to receive_messages(key: 'D1234', name: 'Org', website: 'http://example.com')

        expect {
          importer.import(acronyms, output)
        }.to change(DeliveryOrganisation, :count).by(1)

        delivery_organisation = DeliveryOrganisation.last
        expect(delivery_organisation.natural_key).to eq('D1234')
        expect(delivery_organisation.name).to eq('Org')
        expect(delivery_organisation.website).to eq('http://example.com')

        output.rewind
        expect(output.read).to eq("new organisation: key=D1234, name=Org\n")
      end
    end

    describe 'retired organisation' do
      it 'ignores organisations which are past their end date' do
        allow(organisation).to receive_messages(key: 'D7890', name: 'Org', retired?: true)

        expect {
          importer.import(acronyms, output)
        }.to_not change(DeliveryOrganisation, :count)

        output.rewind
        expect(output.read).to eq("ignoring organisation, retired: key=D7890, name=Org\n")
      end
    end

    describe 'existing organisation, with changes' do
      it 'updates the organisation' do
        FactoryGirl.create(:delivery_organisation, natural_key: 'D5678', name: 'Org', website: 'http://example.com')
        allow(organisation).to receive_messages(key: 'D5678', name: 'New Org', website: 'http://example.org')

        expect {
          importer.import(acronyms, output)
        }.to_not change(DeliveryOrganisation, :count)

        output.rewind
        expect(output.read).to eq("updating organisation: key=D5678, name=New Org\n")
      end
    end

    describe 'existing organisation, without changes' do
      it 'ignores the organisation' do
        FactoryGirl.create(:delivery_organisation, natural_key: 'D5678', name: 'Org', website: 'http://example.com')
        allow(organisation).to receive_messages(key: 'D5678', name: 'Org', website: 'http://example.com')

        expect {
          importer.import(acronyms, output)
        }.to_not change(DeliveryOrganisation, :count)

        output.rewind
        expect(output.read).to eq("ignoring organisation, no changes: key=D5678, name=Org\n")
      end
    end
  end
end
