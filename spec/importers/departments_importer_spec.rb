require 'rails_helper'

RSpec.describe DepartmentsImporter do
  subject(:importer) { DepartmentsImporter.new }

  describe '#import' do
    let(:output) { StringIO.new }
    let(:acronyms) { StringIO.new }

    describe 'new department id' do
      it 'copies the delivery organisation to a department' do
        FactoryBot.create(:delivery_organisation, natural_key: 'D1', name: 'Org', website: 'http://example.com')
        FactoryBot.create(:delivery_organisation, natural_key: 'D1000')

        input = StringIO.new("Organisation ID,Department ID\nD1000,D1\n")

        expect {
          importer.import(input, acronyms, output)
        }.to change(Department, :count).by(1)

        output.rewind
        expect(output.each_line.to_a.first).to eq("promoting delivery organisation to department: key=D1, name=Org\n")
      end
    end

    describe 'existing department id, with updates' do
      it 'updates the fields' do
        department = FactoryBot.create(:department, natural_key: 'D1', name: 'Org', website: 'http://example.com')
        FactoryBot.create(:delivery_organisation, natural_key: 'D1', name: 'Org 2', website: 'http://example.org')
        FactoryBot.create(:delivery_organisation, natural_key: 'D1000')

        input = StringIO.new("Organisation ID,Department ID\nD1000,D1\n")

        importer.import(input, acronyms, output)

        department.reload
        expect(department.name).to eq('Org 2')
        expect(department.website).to eq('http://example.org')

        output.rewind
        expect(output.each_line.to_a.first).to eq("updating department: key=D1, name=Org 2\n")
      end
    end

    describe 'existing department id, without updates' do
      it 'ignores the department' do
        FactoryBot.create(:department, natural_key: 'D1', name: 'Org', website: 'http://example.com')
        FactoryBot.create(:delivery_organisation, natural_key: 'D1', name: 'Org', website: 'http://example.com')
        FactoryBot.create(:delivery_organisation, natural_key: 'D1000')

        input = StringIO.new("Organisation ID,Department ID\nD1000,D1\n")

        importer.import(input, acronyms, output)

        output.rewind
        expect(output.each_line.to_a.first).to eq("ignoring department, no changes: key=D1, name=Org\n")
      end
    end

    describe 'associating a department' do
      it 'updates the delivery organisations department' do
        department = FactoryBot.create(:department, natural_key: 'D1')
        FactoryBot.create(:delivery_organisation, natural_key: 'D1', name: 'Org', website: 'http://example.com')
        delivery_organisation = FactoryBot.create(:delivery_organisation, natural_key: 'D1000')

        input = StringIO.new("Organisation ID,Department ID\nD1000,D1\n")

        importer.import(input, acronyms, output)

        delivery_organisation.reload
        expect(delivery_organisation.department).to eq(department)

        output.rewind
        expect(output.each_line.to_a.last).to eq("updating delivery organisation's department: key=D1000, department_code=D1\n")
      end

      it 'reports if no delivery organisation' do
        FactoryBot.create(:department, natural_key: 'D1')
        FactoryBot.create(:delivery_organisation, natural_key: 'D1', name: 'Org', website: 'http://example.com')

        input = StringIO.new("Organisation ID,Department ID\nD1000,D1\n")

        importer.import(input, acronyms, output)

        output.rewind
        expect(output.each_line.to_a.last).to eq("unknown delivery organisation: key=D1000\n")
      end
    end
  end
end
