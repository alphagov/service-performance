require 'rails_helper'

RSpec.describe GovernmentServiceDataAPI::Client, type: :api do

  subject(:client) { GovernmentServiceDataAPI::Client.new }

  describe '#government' do
    it 'parses the government', cassette: 'government-ok' do
      government = client.government

      expect(government.departments_count).to eq(7)
      expect(government.delivery_organisations_count).to eq(8)
      expect(government.services_count).to eq(31)
    end
  end

  describe '#department' do
    it 'parses the department', cassette: 'department-ok' do
      department = client.department('D0002')

      expect(department.key).to eq('D0002')
      expect(department.name).to eq('Department for Transport')
      expect(department.delivery_organisations_count).to eq(2)
      expect(department.services_count).to eq(9)
    end
  end

  describe '#delivery_organisation' do
    it 'parses the delivery organisation', cassette: 'delivery-organisation-ok' do
      delivery_organisation = client.delivery_organisation('02')

      expect(delivery_organisation.key).to eq('02')
      expect(delivery_organisation.name).to eq('NHS Blood and Transplant')
      expect(delivery_organisation.services_count).to eq(3)
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

  describe '#metrics' do

    context 'for government' do
      let(:entity) { client.government }

      it 'parses the metrics, grouped by government', cassette: 'government-metrics-grouped-government-ok' do
        metrics = client.metrics(entity, group_by: Metrics::Group::Government)

        metric_groups = metrics.metric_groups
        expect(metric_groups.size).to eq(1)

        metric_group = metric_groups.first

        government = metric_group.entity
        expect(government).to be_instance_of(GovernmentServiceDataAPI::Government)
        expect(government.departments_count).to eq(7)
        expect(government.delivery_organisations_count).to eq(8)
        expect(government.services_count).to eq(31)

        transactions_received = metric_group.transactions_received
        expect(transactions_received.total).to eq(746067381)
        expect(transactions_received.online).to eq(648825681)
        expect(transactions_received.phone).to eq(38355269)
        expect(transactions_received.paper).to eq(35775321)
        expect(transactions_received.face_to_face).to eq(0)
        expect(transactions_received.other).to eq(23111110)

        transactions_with_outcome = metric_group.transactions_with_outcome
        expect(transactions_with_outcome.count).to eq(710427383)
        expect(transactions_with_outcome.count_with_intended_outcome).to eq(604814744)
      end

      it 'parses the metrics, grouped by department', cassette: 'government-metrics-grouped-department-ok' do
        metrics = client.metrics(entity, group_by: Metrics::Group::Department)

        metric_groups = metrics.metric_groups
        expect(metric_groups.size).to eq(7)

        metric_group = metric_groups.first

        department = metric_group.entity
        expect(department).to be_instance_of(GovernmentServiceDataAPI::Department)
        expect(department.key).to eq('D0001')
        expect(department.name).to eq('Department for Environment Food & Rural Affairs')
        expect(department.delivery_organisations_count).to eq(1)
        expect(department.services_count).to eq(1)

        transactions_received = metric_group.transactions_received
        expect(transactions_received.total).to eq(3000039)
        expect(transactions_received.online).to eq(1000032)
        expect(transactions_received.phone).to eq(1000003)
        expect(transactions_received.paper).to eq(1000004)
        expect(transactions_received.face_to_face).to eq(0)
        expect(transactions_received.other).to eq(0)

        transactions_with_outcome = metric_group.transactions_with_outcome
        expect(transactions_with_outcome.count).to eq(2435098)
        expect(transactions_with_outcome.count_with_intended_outcome).to eq(2400000)
      end

      it 'parses the metrics, grouped by delivery organisation', cassette: 'government-metrics-grouped-delivery-organisation-ok' do
        metrics = client.metrics(entity, group_by: Metrics::Group::DeliveryOrganisation)

        metric_groups = metrics.metric_groups
        expect(metric_groups.size).to eq(8)

        metric_group = metric_groups.first

        delivery_organisation = metric_group.entity
        expect(delivery_organisation).to be_instance_of(GovernmentServiceDataAPI::DeliveryOrganisation)
        expect(delivery_organisation.key).to eq('01')
        expect(delivery_organisation.name).to eq('Environment Agency')
        expect(delivery_organisation.services_count).to eq(1)

        transactions_received = metric_group.transactions_received
        expect(transactions_received.total).to eq(3000039)
        expect(transactions_received.online).to eq(1000032)
        expect(transactions_received.phone).to eq(1000003)
        expect(transactions_received.paper).to eq(1000004)
        expect(transactions_received.face_to_face).to eq(0)
        expect(transactions_received.other).to eq(0)

        transactions_with_outcome = metric_group.transactions_with_outcome
        expect(transactions_with_outcome.count).to eq(2435098)
        expect(transactions_with_outcome.count_with_intended_outcome).to eq(2400000)
      end

      it 'parses the metrics, grouped by service', cassette: 'government-metrics-grouped-service-ok' do
        metrics = client.metrics(entity, group_by: Metrics::Group::Service)

        metric_groups = metrics.metric_groups
        expect(metric_groups.size).to eq(31)

        metric_group = metric_groups.first

        service = metric_group.entity
        expect(service).to be_instance_of(GovernmentServiceDataAPI::Service)
        expect(service.key).to eq('01')
        expect(service.name).to eq('Buy a fishing rod licence')

        transactions_received = metric_group.transactions_received
        expect(transactions_received.total).to eq(3000039)
        expect(transactions_received.online).to eq(1000032)
        expect(transactions_received.phone).to eq(1000003)
        expect(transactions_received.paper).to eq(1000004)
        expect(transactions_received.face_to_face).to eq(0)
        expect(transactions_received.other).to eq(0)

        transactions_with_outcome = metric_group.transactions_with_outcome
        expect(transactions_with_outcome.count).to eq(2435098)
        expect(transactions_with_outcome.count_with_intended_outcome).to eq(2400000)
      end
    end

    context 'for a department' do
      let(:entity) { client.department('D0002') }

      it 'parses the metrics, grouped by department', cassette: 'department-metrics-grouped-department-ok' do
        metrics = client.metrics(entity, group_by: Metrics::Group::Department)

        metric_groups = metrics.metric_groups
        expect(metric_groups.size).to eq(1)

        metric_group = metric_groups.first

        department = metric_group.entity
        expect(department).to be_instance_of(GovernmentServiceDataAPI::Department)
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

      it 'parses the metrics, grouped by delivery organisation', cassette: 'department-metrics-grouped-delivery-organisation-ok' do
        metrics = client.metrics(entity, group_by: Metrics::Group::DeliveryOrganisation)

        metric_groups = metrics.metric_groups
        expect(metric_groups.size).to eq(2)

        metric_group = metric_groups.first

        delivery_organisation = metric_group.entity
        expect(delivery_organisation).to be_instance_of(GovernmentServiceDataAPI::DeliveryOrganisation)
        expect(delivery_organisation.key).to eq('03')
        expect(delivery_organisation.name).to eq('Driver and Vehicle Licensing Agency')
        expect(delivery_organisation.services_count).to eq(5)

        transactions_received = metric_group.transactions_received
        expect(transactions_received.total).to eq(70123862)
        expect(transactions_received.online).to eq(45143108)
        expect(transactions_received.phone).to eq(7123719)
        expect(transactions_received.paper).to eq(17857035)
        expect(transactions_received.face_to_face).to eq(0)
        expect(transactions_received.other).to eq(0)

        transactions_with_outcome = metric_group.transactions_with_outcome
        expect(transactions_with_outcome.count).to eq(70842643)
        expect(transactions_with_outcome.count_with_intended_outcome).to eq(58650122)
      end

      it 'parses the metrics, grouped by service', cassette: 'department-metrics-grouped-service-ok' do
        metrics = client.metrics(entity, group_by: Metrics::Group::Service)

        metric_groups = metrics.metric_groups
        expect(metric_groups.size).to eq(9)

        metric_group = metric_groups.first

        service = metric_group.entity
        expect(service).to be_instance_of(GovernmentServiceDataAPI::Service)
        expect(service.key).to eq('02')
        expect(service.name).to eq('Apply for a provisional driving license')

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

    context 'for a delivery organisation', cassette: 'metrics-groups-delivery-organisation-ok' do
      let(:entity) { client.delivery_organisation('03') }

      it 'parses the metrics, grouped by delivery organisation', cassette: 'delivery-organisation-metrics-grouped-delivery-organisation-ok' do
        metrics = client.metrics(entity, group_by: Metrics::Group::DeliveryOrganisation)

        metric_groups = metrics.metric_groups
        expect(metric_groups.size).to eq(1)

        metric_group = metric_groups.first

        delivery_organisation = metric_group.entity
        expect(delivery_organisation).to be_instance_of(GovernmentServiceDataAPI::DeliveryOrganisation)
        expect(delivery_organisation.key).to eq('03')
        expect(delivery_organisation.name).to eq('Driver and Vehicle Licensing Agency')
        expect(delivery_organisation.services_count).to eq(5)

        transactions_received = metric_group.transactions_received
        expect(transactions_received.total).to eq(70123862)
        expect(transactions_received.online).to eq(45143108)
        expect(transactions_received.phone).to eq(7123719)
        expect(transactions_received.paper).to eq(17857035)
        expect(transactions_received.face_to_face).to eq(0)
        expect(transactions_received.other).to eq(0)

        transactions_with_outcome = metric_group.transactions_with_outcome
        expect(transactions_with_outcome.count).to eq(70842643)
        expect(transactions_with_outcome.count_with_intended_outcome).to eq(58650122)
      end

      it 'parses the metrics, grouped by service', cassette: 'delivery-organisation-metrics-grouped-service-ok' do
        metrics = client.metrics(entity, group_by: Metrics::Group::Service)

        metric_groups = metrics.metric_groups
        expect(metric_groups.size).to eq(5)

        metric_group = metric_groups.first

        service = metric_group.entity
        expect(service).to be_instance_of(GovernmentServiceDataAPI::Service)
        expect(service.key).to eq('02')
        expect(service.name).to eq('Apply for a provisional driving license')

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

    context 'for a service', cassette: 'metrics-groups-service-ok' do
      let(:entity) { client.service('02') }

      it 'parses the metrics, grouped by service', cassette: 'service-metrics-grouped-service-ok' do
        metrics = client.metrics(entity, group_by: Metrics::Group::Service)

        metric_groups = metrics.metric_groups
        expect(metric_groups.size).to eq(1)

        metric_group = metric_groups.first

        service = metric_group.entity
        expect(service).to be_instance_of(GovernmentServiceDataAPI::Service)
        expect(service.key).to eq('02')
        expect(service.name).to eq('Apply for a provisional driving license')

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
  end
end
