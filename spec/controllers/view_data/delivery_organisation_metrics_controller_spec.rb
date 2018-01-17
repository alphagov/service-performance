require 'rails_helper'

RSpec.describe ViewData::DeliveryOrganisationMetricsController, type: :controller do
  let(:page) { controller.send(:page) }

  describe "GET index" do
    let(:department) { instance_double(Department, natural_key: '001', name: 'Department of Services', to_param: '001') }
    let(:delivery_organisation) { instance_double(DeliveryOrganisation, department: department, name: 'Delivery Organisation of Services', to_param: '1923') }

    before do
      allow(DeliveryOrganisation).to receive_message_chain(:where, :first!) { delivery_organisation }
    end

    it 'finds the delivery organisation' do
      expect(DeliveryOrganisation).to receive(:where).with(natural_key: '1923') { double(first!: delivery_organisation) }
      get :index, params: { delivery_organisation_id: '1923', group_by: Metrics::GroupBy::Service }
    end

    it 'assigns a DeliveryOrganisationMetrics presenter to @metrics' do
      presenter = instance_double(MetricsPresenter)
      expect(MetricsPresenter).to receive(:new).with(delivery_organisation, group_by: Metrics::GroupBy::Service, order: 'asc', order_by: 'name', time_period: TimePeriod.default) { presenter }

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
