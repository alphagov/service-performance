require 'rails_helper'

RSpec.describe ViewData::DeliveryOrganisationMetricsController, type: :controller do
  let(:client) { instance_double(GovernmentServiceDataAPI::Client) }
  let(:page) { controller.send(:page) }

  before do
    allow(controller).to receive(:client) { client }
  end

  describe "GET index" do
    let(:department) { instance_double(GovernmentServiceDataAPI::Department, key: '001', name: 'Department of Services') }
    let(:delivery_organisation) { instance_double(GovernmentServiceDataAPI::DeliveryOrganisation, department: department, name: 'Delivery Organisation of Services') }

    before do
      allow(client).to receive(:delivery_organisation) { delivery_organisation }
    end

    it 'finds the delivery organisation' do
      expect(client).to receive(:delivery_organisation).with('1923') { delivery_organisation }
      get :index, params: { delivery_organisation_id: '1923', group_by: Metrics::GroupBy::Service }
    end

    it 'assigns a DeliveryOrganisationMetrics presenter to @metrics' do
      presenter = instance_double(DeliveryOrganisationMetricsPresenter)
      expect(DeliveryOrganisationMetricsPresenter).to receive(:new).with(delivery_organisation, client: client, group_by: Metrics::GroupBy::Service, order: 'asc', order_by: 'name') { presenter }

      get :index, params: { delivery_organisation_id: '1923', group_by: Metrics::GroupBy::Service, filter: { order: 'asc', order_by: 'name' } }
      expect(assigns[:metrics]).to eq(presenter)
    end

    it 'renders metrics index' do
      get :index, params: { delivery_organisation_id: '1923', group_by: Metrics::GroupBy::Service }
      expect(controller).to have_rendered('view_data/metrics/index')
    end

    it 'sets the breadcrumbs' do
      get :index, params: { delivery_organisation_id: '1923', group_by: Metrics::GroupBy::Service }

      expect(page.breadcrumbs.map { |crumb| [crumb.name, crumb.url] }).to eq([
        ['UK Government', view_data_government_metrics_path],
        ['Department of Services', view_data_department_metrics_path(department_id: '001')],
        ['Delivery Organisation of Services', nil],
      ])
    end
  end
end
