require 'rails_helper'

RSpec.describe Government, type: :model do
  subject(:government) { Government.new }

  describe '#departments_count' do
    it 'returns the total number of departments where 1 service has published data' do
      d1 = FactoryGirl.create(:department, name: "test 1")
      d2 = FactoryGirl.create(:department, name: "test 2")
      d3 = FactoryGirl.create(:department, name: "test 3")

      do1 = FactoryGirl.create(:delivery_organisation, name: "do test 1", department: d1)
      do2 = FactoryGirl.create(:delivery_organisation, name: "do test 2", department: d2)
      do3 = FactoryGirl.create(:delivery_organisation, name: "do test 3", department: d3)

      s = FactoryGirl.create(:service, name: "service test 1", delivery_organisation: do1)
      FactoryGirl.create(:service, name: "service test 2", delivery_organisation: do2)
      FactoryGirl.create(:service, name: "service test 3", delivery_organisation: do3)

      FactoryGirl.create(:monthly_service_metrics, service: s, month: "2017-01-01", published: true)

      expect(government.departments_count).to eq(1)
    end
  end

  describe '#departments_count' do
    it 'returns the total number of departments where all services have published data' do
      d1 = FactoryGirl.create(:department, name: "test 1")
      d2 = FactoryGirl.create(:department, name: "test 2")
      d3 = FactoryGirl.create(:department, name: "test 3")

      do1 = FactoryGirl.create(:delivery_organisation, name: "do test 1", department: d1)
      do2 = FactoryGirl.create(:delivery_organisation, name: "do test 2", department: d2)
      do3 = FactoryGirl.create(:delivery_organisation, name: "do test 3", department: d3)

      s1 = FactoryGirl.create(:service, name: "service test 1", delivery_organisation: do1)
      s2 = FactoryGirl.create(:service, name: "service test 2", delivery_organisation: do2)
      s3 = FactoryGirl.create(:service, name: "service test 3", delivery_organisation: do3)

      FactoryGirl.create(:monthly_service_metrics, service: s1, month: "2017-01-01", published: true)
      FactoryGirl.create(:monthly_service_metrics, service: s2, month: "2017-01-01", published: true)
      FactoryGirl.create(:monthly_service_metrics, service: s3, month: "2017-01-01", published: true)

      expect(government.departments_count).to eq(3)
    end
  end

  describe '#departments_count' do
    it 'returns the total number of departments where no services have published data' do
      d1 = FactoryGirl.create(:department, name: "test 1")
      d2 = FactoryGirl.create(:department, name: "test 2")
      d3 = FactoryGirl.create(:department, name: "test 3")

      do1 = FactoryGirl.create(:delivery_organisation, name: "do test 1", department: d1)
      do2 = FactoryGirl.create(:delivery_organisation, name: "do test 2", department: d2)
      do3 = FactoryGirl.create(:delivery_organisation, name: "do test 3", department: d3)

      FactoryGirl.create(:service, name: "service test 1", delivery_organisation: do1)
      FactoryGirl.create(:service, name: "service test 2", delivery_organisation: do2)
      FactoryGirl.create(:service, name: "service test 3", delivery_organisation: do3)

      expect(government.departments_count).to eq(0)
    end
  end

  describe '#delivery_organisations_count' do
    it 'returns the total number of departments' do
      d1 = FactoryGirl.create(:department, name: "test 1")

      do1 = FactoryGirl.create(:delivery_organisation, name: "do test 1", department: d1)
      do2 = FactoryGirl.create(:delivery_organisation, name: "do test 2", department: d1)

      s1 = FactoryGirl.create(:service, name: "service test 1", delivery_organisation: do1)
      s2 = FactoryGirl.create(:service, name: "service test 2", delivery_organisation: do2)

      FactoryGirl.create(:monthly_service_metrics, month: YearMonth.new(2017, 8), service: s1, published: true)
      FactoryGirl.create(:monthly_service_metrics, month: YearMonth.new(2017, 8), service: s2, published: true)

      expect(government.delivery_organisations_count).to eq(2)
    end
  end

  describe '#services_count' do
    it 'returns the total number of services who have published data correctly' do
      s = FactoryGirl.create(:service)
      FactoryGirl.create(:monthly_service_metrics, month: YearMonth.new(2017, 8), service: s, published: true)

      expect(government.services_count).to eq(1)
    end
    it 'returns the total number of services who have data, but not published, correctly' do
      s = FactoryGirl.create(:service)
      FactoryGirl.create(:monthly_service_metrics, month: YearMonth.new(2017, 8), service: s)

      expect(government.services_count).to eq(0)
    end
    it 'returns the total number of services who have no data correctly' do
      FactoryGirl.create(:service)

      expect(government.services_count).to eq(0)
    end
  end
end
