require 'rails_helper'

RSpec.describe ViewData::ServicesController, type: :controller do
  describe 'GET show' do
    let(:department) { instance_double(Department, natural_key: '001', name: 'Department of Services', to_param: '001') }
    let(:delivery_organisation) { instance_double(DeliveryOrganisation, natural_key: '003', name: 'Delivery Organisation of Services', to_param: '003') }
    let(:service) { instance_double(Service, name: 'The Greatest Service in the World', department: department, delivery_organisation: delivery_organisation, to_param: '2') }

    let(:page) { controller.send(:page) }

    before do
      allow(Service).to receive_message_chain(:where, :first!) { service }
    end

    it 'sets the page title to the service page' do
      get :show, params: { id: '2' }

      expect(page.title).to match(/\AThe Greatest Service in the World/)
    end

    it 'sets the breadcrumbs' do
      get :show, params: { id: '2' }

      expect(page.breadcrumbs.map { |crumb| [crumb.name, crumb.url] }).to eq([
        ['UK Government', view_data_government_metrics_path],
        ['Department of Services', view_data_department_metrics_path(department_id: '001')],
        ['Delivery Organisation of Services', view_data_delivery_organisation_metrics_path(delivery_organisation_id: '003')],
        ['The Greatest Service in the World', nil],
      ])
    end

    it 'sets the breadcrumbs without a delivery organisation' do
      allow(service).to receive(:delivery_organisation) { nil }

      get :show, params: { id: '2' }

      expect(page.breadcrumbs.map { |crumb| [crumb.name, crumb.url] }).to eq([
        ['UK Government', view_data_government_metrics_path],
        ['Department of Services', view_data_department_metrics_path(department_id: '001')],
        ['The Greatest Service in the World', nil],
      ])
    end
  end
end
