require 'rails_helper'

RSpec.describe DeliveryOrganisationMetricsController, type: :controller do
  let(:client) { instance_double(CrossGovernmentServiceDataAPI::Client) }

  before do
    allow(controller).to receive(:client) { client }
  end

  describe "GET index" do
    let(:delivery_organisation) { instance_double(CrossGovernmentServiceDataAPI::DeliveryOrganisation) }

    before do
      allow(client).to receive(:delivery_organisation) { delivery_organisation }
    end

    it 'finds the delivery organisation' do
      expect(client).to receive(:delivery_organisation).with('1923') { delivery_organisation }
      get :index, params: { delivery_organisation_id: '1923', group_by: Metrics::Group::Service }
    end

    it 'assigns a DeliveryOrganisationMetrics presenter to @metrics' do
      presenter = instance_double(DeliveryOrganisationMetricsPresenter)
      expect(DeliveryOrganisationMetricsPresenter).to receive(:new).with(delivery_organisation, client: client, group_by: Metrics::Group::Service, order: 'asc', order_by: 'name') { presenter }

      get :index, params: { delivery_organisation_id: '1923', group_by: Metrics::Group::Service, filter: { order: 'asc', order_by: 'name' }}
      expect(assigns[:metrics]).to eq(presenter)
    end

    it 'renders metrics index' do
      get :index, params: { delivery_organisation_id: '1923', group_by: Metrics::Group::Service }
      expect(controller).to have_rendered('metrics/index')
    end
  end
end
