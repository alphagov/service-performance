require 'rails_helper'

RSpec.describe DepartmentMetricsController, type: :controller do
  let(:client) { instance_double(GovernmentServiceDataAPI::Client) }
  let(:page) { controller.send(:page) }

  before do
    allow(controller).to receive(:client) { client }
  end

  describe "GET index" do
    let(:department) { instance_double(GovernmentServiceDataAPI::Department, name: 'Department of Services') }

    before do
      allow(client).to receive(:department) { department }
    end

    it 'finds the department' do
      expect(client).to receive(:department).with('D001') { department }
      get :index, params: { department_id: 'D001', group_by: Metrics::Group::DeliveryOrganisation }
    end

    it 'assigns a DepartmentMetrics presenter to @metrics' do
      presenter = instance_double(DepartmentMetricsPresenter)
      expect(DepartmentMetricsPresenter).to receive(:new).with(department, client: client, group_by: Metrics::Group::DeliveryOrganisation, order: 'asc', order_by: 'name') { presenter }

      get :index, params: { department_id: 'D001', group_by: Metrics::Group::DeliveryOrganisation, filter: { order: 'asc', order_by: 'name' } }
      expect(assigns[:metrics]).to eq(presenter)
    end

    it 'renders metrics index' do
      get :index, params: { department_id: 'D001', group_by: Metrics::Group::DeliveryOrganisation }
      expect(controller).to have_rendered('view_data/metrics/index')
    end

    it 'sets the breadcrumbs' do
      get :index, params: { department_id: 'D001', group_by: Metrics::Group::DeliveryOrganisation }

      expect(page.breadcrumbs.map { |crumb| [crumb.name, crumb.url] }).to eq([
        ['UK Government', government_metrics_path],
        ['Department of Services', nil],
      ])
    end
  end
end
