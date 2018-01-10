require 'rails_helper'

RSpec.describe ViewData::GovernmentMetricsController, type: :controller do
  let(:page) { controller.send(:page) }

  describe "GET index" do
    let(:government) { instance_double(Government) }

    before do
      allow(Government).to receive(:new) { government }
    end

    it 'assigns a GovernmentMetrics presenter to @metrics' do
      presenter = instance_double(MetricsPresenter)
      expect(MetricsPresenter).to receive(:new).with(government, group_by: Metrics::GroupBy::Department, order: 'asc', order_by: 'name', search_term: nil) { presenter }

      get :index, params: { group_by: Metrics::GroupBy::Department, filter: { order: 'asc', order_by: 'name' } }
      expect(assigns[:metrics]).to eq(presenter)
    end

    it 'renders metrics index' do
      get :index, params: { group_by: Metrics::GroupBy::Department }
      expect(controller).to have_rendered('view_data/metrics/index')
    end

    it 'sets the breadcrumbs' do
      get :index, params: { group_by: Metrics::GroupBy::Department }

      expect(page.breadcrumbs.map { |crumb| [crumb.name, crumb.url] }).to eq([
        ['UK Government', nil],
      ])
    end
  end
end
