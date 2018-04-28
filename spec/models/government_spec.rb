require 'rails_helper'

RSpec.describe Government, type: :model do
  subject(:government) { Government.new }

  describe '#departments_count' do
    it 'returns the total number of departments where 1 service has published data' do
      d1 = FactoryBot.create(:department, name: "test 1")
      d2 = FactoryBot.create(:department, name: "test 2")
      d3 = FactoryBot.create(:department, name: "test 3")

      do1 = FactoryBot.create(:delivery_organisation, name: "do test 1", department: d1)
      do2 = FactoryBot.create(:delivery_organisation, name: "do test 2", department: d2)
      do3 = FactoryBot.create(:delivery_organisation, name: "do test 3", department: d3)

      s = FactoryBot.create(:service, name: "service test 1", delivery_organisation: do1)
      FactoryBot.create(:service, name: "service test 2", delivery_organisation: do2)
      FactoryBot.create(:service, name: "service test 3", delivery_organisation: do3)

      FactoryBot.create(:monthly_service_metrics, service: s, month: "2017-01-01", published: true)

      expect(government.departments_count).to eq(1)
    end
  end

  describe '#departments_count' do
    it 'returns the total number of departments where all services have published data' do
      d1 = FactoryBot.create(:department, name: "test 1")
      d2 = FactoryBot.create(:department, name: "test 2")
      d3 = FactoryBot.create(:department, name: "test 3")

      do1 = FactoryBot.create(:delivery_organisation, name: "do test 1", department: d1)
      do2 = FactoryBot.create(:delivery_organisation, name: "do test 2", department: d2)
      do3 = FactoryBot.create(:delivery_organisation, name: "do test 3", department: d3)

      s1 = FactoryBot.create(:service, name: "service test 1", delivery_organisation: do1)
      s2 = FactoryBot.create(:service, name: "service test 2", delivery_organisation: do2)
      s3 = FactoryBot.create(:service, name: "service test 3", delivery_organisation: do3)

      FactoryBot.create(:monthly_service_metrics, service: s1, month: "2017-01-01", published: true)
      FactoryBot.create(:monthly_service_metrics, service: s2, month: "2017-01-01", published: true)
      FactoryBot.create(:monthly_service_metrics, service: s3, month: "2017-01-01", published: true)

      expect(government.departments_count).to eq(3)
    end
  end

  describe '#departments_count' do
    it 'returns the total number of departments where no services have published data' do
      d1 = FactoryBot.create(:department, name: "test 1")
      d2 = FactoryBot.create(:department, name: "test 2")
      d3 = FactoryBot.create(:department, name: "test 3")

      do1 = FactoryBot.create(:delivery_organisation, name: "do test 1", department: d1)
      do2 = FactoryBot.create(:delivery_organisation, name: "do test 2", department: d2)
      do3 = FactoryBot.create(:delivery_organisation, name: "do test 3", department: d3)

      FactoryBot.create(:service, name: "service test 1", delivery_organisation: do1)
      FactoryBot.create(:service, name: "service test 2", delivery_organisation: do2)
      FactoryBot.create(:service, name: "service test 3", delivery_organisation: do3)

      expect(government.departments_count).to eq(0)
    end
  end

  describe '#delivery_organisations_count' do
    it 'returns the total number of departments' do
      d1 = FactoryBot.create(:department, name: "test 1")

      do1 = FactoryBot.create(:delivery_organisation, name: "do test 1", department: d1)
      do2 = FactoryBot.create(:delivery_organisation, name: "do test 2", department: d1)

      s1 = FactoryBot.create(:service, name: "service test 1", delivery_organisation: do1)
      s2 = FactoryBot.create(:service, name: "service test 2", delivery_organisation: do2)

      FactoryBot.create(:monthly_service_metrics, month: YearMonth.new(2017, 8), service: s1, published: true)
      FactoryBot.create(:monthly_service_metrics, month: YearMonth.new(2017, 8), service: s2, published: true)

      expect(government.delivery_organisations_count).to eq(2)
    end
  end

  describe '#services_count' do
    it 'returns the total number of services who have published data correctly' do
      s = FactoryBot.create(:service)
      FactoryBot.create(:monthly_service_metrics, month: YearMonth.new(2017, 8), service: s, published: true)

      expect(government.services_count).to eq(1)
    end
    it 'returns the total number of services who have data, but not published, correctly' do
      s = FactoryBot.create(:service)
      FactoryBot.create(:monthly_service_metrics, month: YearMonth.new(2017, 8), service: s)

      expect(government.services_count).to eq(0)
    end
    it 'returns the total number of services who have no data correctly' do
      FactoryBot.create(:service)

      expect(government.services_count).to eq(0)
    end
  end
end
