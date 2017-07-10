require 'rails_helper'

RSpec.describe GovernmentMetricsController, type: :controller do
  let(:client) { instance_double(CrossGovernmentServiceDataAPI::Client) }

  before do
    allow(controller).to receive(:client) { client }
  end

  describe "GET index" do
    let(:government) { instance_double(CrossGovernmentServiceDataAPI::Government) }

    before do
      allow(client).to receive(:government) { government }
    end

    it 'finds government' do
      expect(client).to receive(:government) { government }
      get :index, params: { group_by: Metrics::Group::Department }
    end

    it 'assigns a GovernmentMetrics presenter to @metrics' do
      presenter = instance_double(GovernmentMetricsPresenter)
      expect(GovernmentMetricsPresenter).to receive(:new).with(government, client: client, group_by: Metrics::Group::Department, order: 'asc', order_by: 'name') { presenter }

      get :index, params: { group_by: Metrics::Group::Department, filter: { order: 'asc', order_by: 'name' }}
      expect(assigns[:metrics]).to eq(presenter)
    end

    it 'renders metrics index' do
      get :index, params: { group_by: Metrics::Group::Department }
      expect(controller).to have_rendered('metrics/index')
    end
  end
end
