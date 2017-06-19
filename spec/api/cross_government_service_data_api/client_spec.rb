require 'rails_helper'

RSpec.describe CrossGovernmentServiceDataAPI::Client, type: :api do

  subject(:client) { CrossGovernmentServiceDataAPI::Client.new }

  describe '#metrics_by_department' do
    it 'parses the metrics', cassette: 'department-ok' do
      metric_groups = client.metrics_by_department

      metric_group = metric_groups.detect {|metric_group| metric_group.department.name == 'Department for Transport' }

      department = metric_group.department
      expect(department.key).to eq('D0002')
      expect(department.name).to eq('Department for Transport')
      expect(department.delivery_organisations_count).to eq(2)
      expect(department.services_count).to eq(9)

      transactions_received = metric_group.transactions_received
      expect(transactions_received.total).to eq(118679511)
      expect(transactions_received.online).to eq(70711048)
      expect(transactions_received.phone).to eq(10123774)
      expect(transactions_received.paper).to eq(17857035)
      expect(transactions_received.face_to_face).to eq(0)
      expect(transactions_received.other).to eq(19987654)

      transactions_with_outcome = metric_group.transactions_with_outcome
      expect(transactions_with_outcome.count).to eq(114587788)
      expect(transactions_with_outcome.count_with_intended_outcome).to eq(92321116)
    end
  end

  describe '#services_metrics_by_department' do
    it 'parses the metrics', cassette: 'department-services-ok' do
      metric_groups = client.services_metrics_by_department('D0002')

      metric_group = metric_groups.detect {|metric_group| metric_group.service.name == 'Apply for a provisional driving license' }

      service = metric_group.service
      expect(service.name).to eq('Apply for a provisional driving license')
      expect(service.purpose).to eq('Why the service was built, its policy objectives and the user need it meets.')
      expect(service.how_it_works).to eq('The processes and back-office operations that allow the service to operate.')
      expect(service.typical_users).to eq('Each of the service’s key user groups with their respective demographic, geographic distribution and other relevant details.')
      expect(service.frequency_used).to eq('On average, how often each of the key user groups uses the service.')
      expect(service.duration_until_outcome).to eq('The average amount of time for each of the key user groups that it takes for a received transaction to end in an outcome.')
      expect(service.start_page_url).to eq('https://example.com')
      expect(service.paper_form_url).to eq('https://example.com')

      department = metric_group.department
      expect(department.key).to eq('D0002')
      expect(department.name).to eq('Department for Transport')
      expect(department.delivery_organisations_count).to eq(2)
      expect(department.services_count).to eq(9)

      transactions_received = metric_group.transactions_received
      expect(transactions_received.total).to eq(2000093)
      expect(transactions_received.online).to eq(1000050)
      expect(transactions_received.phone).to eq(1000043)
      expect(transactions_received.paper).to eq(0)
      expect(transactions_received.face_to_face).to eq(0)
      expect(transactions_received.other).to eq(0)

      transactions_with_outcome = metric_group.transactions_with_outcome
      expect(transactions_with_outcome.count).to eq(1735098)
      expect(transactions_with_outcome.count_with_intended_outcome).to eq(1500000)
    end
  end


  describe '#service' do
    it 'parses the service', cassette: 'service-ok' do
      service = client.service('02')

      expect(service.name).to eq('Apply for a provisional driving license')
      expect(service.purpose).to eq('Why the service was built, its policy objectives and the user need it meets.')
      expect(service.how_it_works).to eq('The processes and back-office operations that allow the service to operate.')
      expect(service.typical_users).to eq('Each of the service’s key user groups with their respective demographic, geographic distribution and other relevant details.')
      expect(service.frequency_used).to eq('On average, how often each of the key user groups uses the service.')
      expect(service.duration_until_outcome).to eq('The average amount of time for each of the key user groups that it takes for a received transaction to end in an outcome.')
      expect(service.start_page_url).to eq('https://example.com')
      expect(service.paper_form_url).to eq('https://example.com')

      department = service.department
      expect(department.key).to eq('D0002')
      expect(department.name).to eq('Department for Transport')
      expect(department.delivery_organisations_count).to eq(2)
      expect(department.services_count).to eq(9)
    end
  end

end
