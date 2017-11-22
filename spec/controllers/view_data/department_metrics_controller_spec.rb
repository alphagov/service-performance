require 'rails_helper'

RSpec.describe ViewData::DepartmentMetricsController, type: :controller do
  let(:page) { controller.send(:page) }

  describe "GET index" do
    let(:department) { instance_double(Department, name: 'Department of Services') }

    before do
      allow(Department).to receive_message_chain(:where, :first!) { department }
    end

    it 'finds the department' do
      expect(Department).to receive(:where).with(natural_key: 'D001') { double(first!: department) }
      get :index, params: { department_id: 'D001', group_by: Metrics::GroupBy::DeliveryOrganisation }
    end

    it 'assigns a DepartmentMetrics presenter to @metrics' do
      presenter = instance_double(MetricsPresenter)
      expect(MetricsPresenter).to receive(:new).with(department, group_by: Metrics::GroupBy::DeliveryOrganisation, order: 'asc', order_by: 'name') { presenter }

      get :index, params: { department_id: 'D001', group_by: Metrics::GroupBy::DeliveryOrganisation, filter: { order: 'asc', order_by: 'name' } }
      expect(assigns[:metrics]).to eq(presenter)
    end

    it 'renders metrics index' do
      get :index, params: { department_id: 'D001', group_by: Metrics::GroupBy::DeliveryOrganisation }
      expect(controller).to have_rendered('view_data/metrics/index')
    end

    it 'sets the breadcrumbs' do
      get :index, params: { department_id: 'D001', group_by: Metrics::GroupBy::DeliveryOrganisation }

      expect(page.breadcrumbs.map { |crumb| [crumb.name, crumb.url] }).to eq([
        ['UK Government', view_data_government_metrics_path],
        ['Department of Services', nil],
      ])
    end
  end
end
