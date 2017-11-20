require 'rails_helper'
include GovernmentServiceDataAPI::MetricStatus

RSpec.describe GovernmentServiceDataAPI::Client, type: :api do
  subject(:client) { GovernmentServiceDataAPI::Client.new }

  describe '#government' do
    it 'parses the government', cassette: 'government-ok' do
      government = client.government

      expect(government.departments_count).to eq(7)
      expect(government.delivery_organisations_count).to eq(15)
      expect(government.services_count).to eq(34)
    end
  end

  describe '#department' do
    it 'parses the department', cassette: 'department-ok' do
      department = client.department('D9')

      expect(department.key).to eq('D9')
      expect(department.name).to eq('Department for Transport')
      expect(department.delivery_organisations_count).to eq(1)
      expect(department.services_count).to eq(1)
    end
  end

  describe '#delivery_organisation' do
    let(:delivery_organisation) { client.delivery_organisation('EA39') }

    it 'parses the delivery organisation', cassette: 'delivery-organisation-ok' do
      expect(delivery_organisation.key).to eq('EA39')
      expect(delivery_organisation.name).to eq('Planning Inspectorate')
      expect(delivery_organisation.services_count).to eq(2)
    end

    it 'parses the department', cassette: 'delivery-organisation-ok' do
      department = delivery_organisation.department

      expect(department.key).to eq('D4')
      expect(department.name).to eq('Department for Communities and Local Government')
      expect(department.website).to eq('https://www.gov.uk/government/organisations/department-for-communities-and-local-government')
      expect(department.delivery_organisations_count).to eq(1)
      expect(department.services_count).to eq(2)
    end
  end

  describe '#service' do
    let(:service) { client.service('32f3') }

    it 'parses the service', cassette: 'service-ok' do
      expect(service.name).to include('National Infrastructure applications')
      expect(service.purpose).to include('The Planning Inspectorate became the agency responsible for operating the planning process for nationally significant infrastructure projects (NSIPs)')
      expect(service.how_it_works).to include('The process comprises six key stages, including pre-application, acceptance, pre-examination')
      expect(service.typical_users).to include('National infrastructure project applicants')
      expect(service.frequency_used).to include('')
      expect(service.duration_until_outcome).to include('28 days')
      expect(service.start_page_url).to be_nil
      expect(service.paper_form_url).to be_nil
    end

    it 'parses the delivery organisation', cassette: 'service-ok' do
      delivery_organisation = service.delivery_organisation

      expect(delivery_organisation.key).to eq('EA39')
      expect(delivery_organisation.name).to eq('Planning Inspectorate')
      expect(delivery_organisation.services_count).to eq(2)
    end

    it 'parses the department', cassette: 'service-ok' do
      department = service.department

      expect(department.key).to eq('D4')
      expect(department.name).to eq('Department for Communities and Local Government')
      expect(department.delivery_organisations_count).to eq(1)
      expect(department.services_count).to eq(2)
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
        expect(government.delivery_organisations_count).to eq(15)
        expect(government.services_count).to eq(34)

        transactions_received = metric_group.transactions_received
        expect(transactions_received.total).to eq(26592298)
        expect(transactions_received.online).to eq(24174736)
        expect(transactions_received.phone).to eq(642708)
        expect(transactions_received.paper).to eq(1475717)
        expect(transactions_received.face_to_face).to eq(NOT_APPLICABLE)
        expect(transactions_received.other).to eq(299137)

        transactions_with_outcome = metric_group.transactions_with_outcome
        expect(transactions_with_outcome.count).to eq(24724920)
        expect(transactions_with_outcome.count_with_intended_outcome).to eq(22528488)

        calls_received = metric_group.calls_received
        expect(calls_received.total).to eq(1771419)
        expect(calls_received.perform_transaction).to eq(642708)
        expect(calls_received.get_information).to eq(81518)
      end

      it 'parses the metrics, grouped by department', cassette: 'government-metrics-grouped-department-ok' do
        metrics = client.metrics(entity, group_by: Metrics::Group::Department)

        metric_groups = metrics.metric_groups
        expect(metric_groups.size).to eq(7)

        metric_group = metric_groups.first

        department = metric_group.entity
        expect(department).to be_instance_of(GovernmentServiceDataAPI::Department)
        expect(department.key).to eq('D1198')
        expect(department.name).to eq('Department for Business, Energy & Industrial Strategy')
        expect(department.delivery_organisations_count).to eq(2)
        expect(department.services_count).to eq(4)

        transactions_received = metric_group.transactions_received
        expect(transactions_received.total).to eq(4436917)
        expect(transactions_received.online).to eq(3767723)
        expect(transactions_received.phone).to eq(:not_provided)
        expect(transactions_received.paper).to eq(477016)
        expect(transactions_received.face_to_face).to eq(NOT_APPLICABLE)
        expect(transactions_received.other).to eq(192178)

        transactions_with_outcome = metric_group.transactions_with_outcome
        expect(transactions_with_outcome.count).to eq(4435688)
        expect(transactions_with_outcome.count_with_intended_outcome).to eq(4284853)

        calls_received = metric_group.calls_received
        expect(calls_received.total).to eq(1700)
        expect(calls_received.perform_transaction).to eq(NOT_PROVIDED)
        expect(calls_received.get_information).to eq(615)
      end

      it 'parses the metrics, grouped by delivery organisation', cassette: 'government-metrics-grouped-delivery-organisation-ok' do
        metrics = client.metrics(entity, group_by: Metrics::Group::DeliveryOrganisation)

        metric_groups = metrics.metric_groups
        expect(metric_groups.size).to eq(15)

        metric_group = metric_groups.first

        delivery_organisation = metric_group.entity
        expect(delivery_organisation).to be_instance_of(GovernmentServiceDataAPI::DeliveryOrganisation)
        expect(delivery_organisation.key).to eq('EA26')
        expect(delivery_organisation.name).to eq('Companies House')
        expect(delivery_organisation.services_count).to eq(2)

        transactions_received = metric_group.transactions_received
        expect(transactions_received.total).to eq(4208822)
        expect(transactions_received.online).to eq(3738643)
        expect(transactions_received.phone).to eq(NOT_APPLICABLE)
        expect(transactions_received.paper).to eq(470179)
        expect(transactions_received.face_to_face).to eq(NOT_APPLICABLE)
        expect(transactions_received.other).to eq(NOT_APPLICABLE)

        transactions_with_outcome = metric_group.transactions_with_outcome
        expect(transactions_with_outcome.count).to eq(4208762)
        expect(transactions_with_outcome.count_with_intended_outcome).to eq(4059933)

        calls_received = metric_group.calls_received
        expect(calls_received.total).to eq(NOT_APPLICABLE)
        expect(calls_received.perform_transaction).to eq(NOT_APPLICABLE)
        expect(calls_received.get_information).to eq(NOT_APPLICABLE)
      end

      it 'parses the metrics, grouped by service', cassette: 'government-metrics-grouped-service-ok' do
        metrics = client.metrics(entity, group_by: Metrics::Group::Service)

        metric_groups = metrics.metric_groups
        expect(metric_groups.size).to eq(34)

        metric_group = metric_groups.first

        service = metric_group.entity
        expect(service).to be_instance_of(GovernmentServiceDataAPI::Service)
        expect(service.key).to eq('a747')
        expect(service.name).to eq('File your Confirmation Statement')

        transactions_received = metric_group.transactions_received
        expect(transactions_received.total).to eq(2376368)
        expect(transactions_received.online).to eq(2346705)
        expect(transactions_received.phone).to eq(NOT_APPLICABLE)
        expect(transactions_received.paper).to eq(29663)
        expect(transactions_received.face_to_face).to eq(NOT_APPLICABLE)
        expect(transactions_received.other).to eq(NOT_APPLICABLE)

        transactions_with_outcome = metric_group.transactions_with_outcome
        expect(transactions_with_outcome.count).to eq(2376308)
        expect(transactions_with_outcome.count_with_intended_outcome).to eq(2284487)

        calls_received = metric_group.calls_received
        expect(calls_received.total).to eq(NOT_APPLICABLE)
        expect(calls_received.perform_transaction).to eq(NOT_APPLICABLE)
        expect(calls_received.get_information).to eq(NOT_APPLICABLE)
      end
    end

    context 'for a department' do
      let(:entity) { client.department('D18') }

      it 'parses the metrics, grouped by department', cassette: 'department-metrics-grouped-department-ok' do
        metrics = client.metrics(entity, group_by: Metrics::Group::Department)

        metric_groups = metrics.metric_groups
        expect(metric_groups.size).to eq(1)

        metric_group = metric_groups.first

        department = metric_group.entity
        expect(department).to be_instance_of(GovernmentServiceDataAPI::Department)
        expect(department.key).to eq('D18')
        expect(department.name).to eq('Ministry of Justice')
        expect(department.delivery_organisations_count).to eq(2)
        expect(department.services_count).to eq(2)

        transactions_received = metric_group.transactions_received
        expect(transactions_received.total).to eq(58140)
        expect(transactions_received.online).to eq(14980)
        expect(transactions_received.phone).to eq(0)
        expect(transactions_received.paper).to eq(38659)
        expect(transactions_received.face_to_face).to eq(NOT_APPLICABLE)
        expect(transactions_received.other).to eq(4501)

        transactions_with_outcome = metric_group.transactions_with_outcome
        expect(transactions_with_outcome.count).to eq(58140)
        expect(transactions_with_outcome.count_with_intended_outcome).to eq(2931)

        calls_received = metric_group.calls_received
        expect(calls_received.total).to eq(0)
        expect(calls_received.perform_transaction).to eq(0)
        expect(calls_received.get_information).to eq(0)
      end

      it 'parses the metrics, grouped by delivery organisation', cassette: 'department-metrics-grouped-delivery-organisation-ok' do
        metrics = client.metrics(entity, group_by: Metrics::Group::DeliveryOrganisation)

        metric_groups = metrics.metric_groups
        expect(metric_groups.size).to eq(2)

        metric_group = metric_groups.first

        delivery_organisation = metric_group.entity
        expect(delivery_organisation).to be_instance_of(GovernmentServiceDataAPI::DeliveryOrganisation)
        expect(delivery_organisation.key).to eq('EA73')
        expect(delivery_organisation.name).to eq('HM Courts & Tribunals Service')
        expect(delivery_organisation.services_count).to eq(1)

        transactions_received = metric_group.transactions_received
        expect(transactions_received.total).to eq(6149)
        expect(transactions_received.online).to eq(773)
        expect(transactions_received.phone).to eq(0)
        expect(transactions_received.paper).to eq(875)
        expect(transactions_received.face_to_face).to eq(NOT_APPLICABLE)
        expect(transactions_received.other).to eq(4501)

        transactions_with_outcome = metric_group.transactions_with_outcome
        expect(transactions_with_outcome.count).to eq(6149)
        expect(transactions_with_outcome.count_with_intended_outcome).to eq(2931)

        calls_received = metric_group.calls_received
        expect(calls_received.total).to eq(0)
        expect(calls_received.perform_transaction).to eq(0)
        expect(calls_received.get_information).to eq(0)
      end

      it 'parses the metrics, grouped by service', cassette: 'department-metrics-grouped-service-ok' do
        metrics = client.metrics(entity, group_by: Metrics::Group::Service)

        metric_groups = metrics.metric_groups
        expect(metric_groups.size).to eq(2)

        metric_group = metric_groups.first

        service = metric_group.entity
        expect(service).to be_instance_of(GovernmentServiceDataAPI::Service)
        expect(service.key).to eq('b64d')
        expect(service.name).to eq('Appeal to the tax tribunal')

        transactions_received = metric_group.transactions_received
        expect(transactions_received.total).to eq(6149)
        expect(transactions_received.online).to eq(773)
        expect(transactions_received.phone).to eq(0)
        expect(transactions_received.paper).to eq(875)
        expect(transactions_received.face_to_face).to eq(NOT_APPLICABLE)
        expect(transactions_received.other).to eq(4501)

        transactions_with_outcome = metric_group.transactions_with_outcome
        expect(transactions_with_outcome.count).to eq(6149)
        expect(transactions_with_outcome.count_with_intended_outcome).to eq(2931)

        calls_received = metric_group.calls_received
        expect(calls_received.total).to eq(0)
        expect(calls_received.perform_transaction).to eq(0)
        expect(calls_received.get_information).to eq(0)
      end
    end

    context 'for a delivery organisation', cassette: 'metrics-groups-delivery-organisation-ok' do
      let(:entity) { client.delivery_organisation('D7') }

      it 'parses the metrics, grouped by delivery organisation', cassette: 'delivery-organisation-metrics-grouped-delivery-organisation-ok' do
        metrics = client.metrics(entity, group_by: Metrics::Group::DeliveryOrganisation)

        metric_groups = metrics.metric_groups
        expect(metric_groups.size).to eq(1)

        metric_group = metric_groups.first

        delivery_organisation = metric_group.entity
        expect(delivery_organisation).to be_instance_of(GovernmentServiceDataAPI::DeliveryOrganisation)
        expect(delivery_organisation.key).to eq('D7')
        expect(delivery_organisation.name).to eq('Department for Environment, Food & Rural Affairs')
        expect(delivery_organisation.services_count).to eq(2)

        transactions_received = metric_group.transactions_received
        expect(transactions_received.total).to eq(323158)
        expect(transactions_received.online).to eq(259741)
        expect(transactions_received.phone).to eq(0)
        expect(transactions_received.paper).to eq(63417)
        expect(transactions_received.face_to_face).to eq(NOT_APPLICABLE)
        expect(transactions_received.other).to eq(0)

        transactions_with_outcome = metric_group.transactions_with_outcome
        expect(transactions_with_outcome.count).to eq(320388)
        expect(transactions_with_outcome.count_with_intended_outcome).to eq(304268)

        calls_received = metric_group.calls_received
        expect(calls_received.total).to eq(4630)
        expect(calls_received.perform_transaction).to eq(0)
        expect(calls_received.get_information).to eq(4238)
      end

      it 'parses the metrics, grouped by service', cassette: 'delivery-organisation-metrics-grouped-service-ok' do
        metrics = client.metrics(entity, group_by: Metrics::Group::Service)

        metric_groups = metrics.metric_groups
        expect(metric_groups.size).to eq(2)

        metric_group = metric_groups.first

        service = metric_group.entity
        expect(service).to be_instance_of(GovernmentServiceDataAPI::Service)
        expect(service.key).to eq('924a')
        expect(service.name).to eq('Apply to release genetically modified organisms')

        transactions_received = metric_group.transactions_received
        expect(transactions_received.total).to eq(2)
        expect(transactions_received.online).to eq(2)
        expect(transactions_received.phone).to eq(NOT_APPLICABLE)
        expect(transactions_received.paper).to eq(NOT_APPLICABLE)
        expect(transactions_received.face_to_face).to eq(NOT_APPLICABLE)
        expect(transactions_received.other).to eq(NOT_APPLICABLE)

        transactions_with_outcome = metric_group.transactions_with_outcome
        expect(transactions_with_outcome.count).to eq(1)
        expect(transactions_with_outcome.count_with_intended_outcome).to eq(1)

        calls_received = metric_group.calls_received
        expect(calls_received.total).to eq(NOT_APPLICABLE)
        expect(calls_received.perform_transaction).to eq(NOT_APPLICABLE)
        expect(calls_received.get_information).to eq(NOT_APPLICABLE)
      end
    end

    context 'for a service', cassette: 'metrics-groups-service-ok' do
      let(:entity) { client.service('51f2') }

      it 'parses the metrics, grouped by service', cassette: 'service-metrics-grouped-service-ok' do
        metrics = client.metrics(entity, group_by: Metrics::Group::Service)

        metric_groups = metrics.metric_groups
        expect(metric_groups.size).to eq(1)

        metric_group = metric_groups.first

        service = metric_group.entity
        expect(service).to be_instance_of(GovernmentServiceDataAPI::Service)
        expect(service.key).to eq('51f2')
        expect(service.name).to eq('Cattle Tracing System')

        transactions_received = metric_group.transactions_received
        expect(transactions_received.total).to eq(10120880)
        expect(transactions_received.online).to eq(9480557)
        expect(transactions_received.phone).to eq(NOT_PROVIDED)
        expect(transactions_received.paper).to eq(640323)
        expect(transactions_received.face_to_face).to eq(NOT_APPLICABLE)
        expect(transactions_received.other).to eq(NOT_APPLICABLE)

        transactions_with_outcome = metric_group.transactions_with_outcome
        expect(transactions_with_outcome.count).to eq(10219899)
        expect(transactions_with_outcome.count_with_intended_outcome).to eq(10117919)

        calls_received = metric_group.calls_received
        expect(calls_received.total).to eq(101980)
        expect(calls_received.perform_transaction).to eq(NOT_PROVIDED)
        expect(calls_received.get_information).to eq(NOT_PROVIDED)
      end
    end
  end
end
