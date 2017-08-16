require 'rails_helper'

RSpec.describe ServicesController, type: :controller do
  describe 'GET show' do
    let(:client) { instance_double(GovernmentServiceDataAPI::Client, service: service) }

    let(:department) { instance_double(GovernmentServiceDataAPI::Department, key: '001', name: 'Department of Services') }
    let(:delivery_organisation) { instance_double(GovernmentServiceDataAPI::DeliveryOrganisation, key: '003', name: 'Delivery Organisation of Services') }
    let(:service) { instance_double(GovernmentServiceDataAPI::Service, name: 'The Greatest Service in the World', department: department, delivery_organisation: delivery_organisation) }

    before do
      allow(GovernmentServiceDataAPI::Client).to receive(:new) { client }
    end

    let(:page) { controller.send(:page) }

    it 'sets the page title to the service page' do
      get :show, params: { id: '2' }

      expect(page.title).to match(/\AThe Greatest Service in the World/)
    end

    it 'sets the breadcrumbs' do
      get :show, params: { id: '2' }

      expect(page.breadcrumbs.map { |crumb| [crumb.name, crumb.url] }).to eq([
        ['UK Government', government_metrics_path],
        ['Department of Services', department_metrics_path(department_id: '001')],
        ['Delivery Organisation of Services', delivery_organisation_metrics_path(delivery_organisation_id: '003')],
        ['The Greatest Service in the World', nil],
      ])
    end

    it 'sets the breadcrumbs without a delivery organisation' do
      allow(service).to receive(:delivery_organisation) { nil }

      get :show, params: { id: '2' }

      expect(page.breadcrumbs.map { |crumb| [crumb.name, crumb.url] }).to eq([
        ['UK Government', government_metrics_path],
        ['Department of Services', department_metrics_path(department_id: '001')],
        ['The Greatest Service in the World', nil],
      ])
    end
  end
end
