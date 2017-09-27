require 'rails_helper'

RSpec.describe MonthlyServiceMetricsController, type: :controller do
  shared_examples_for 'validating publish token' do
    context 'with an invalid publish token' do
      before do
        allow(MonthlyServiceMetricsPublishToken).to receive(:valid?).with(token: publish_token, metrics: metrics) { false }
      end

      it 'renders invalid template' do
        dispatch
        expect(response.status).to eq(401)
        expect(response).to render_template('monthly_service_metrics/invalid_publish_token')
      end
    end
  end

  describe 'GET edit' do
    def dispatch
      get :edit, params: { service_id: service.id, year: '2017', month: '06', publish_token: publish_token }
    end

    let(:publish_token) { 'PuBlIsHtOkEn' }
    let(:metrics) { instance_double(MonthlyServiceMetrics, :service= => nil, :month= => nil) }
    let(:service) { instance_double(Service, id: '01') }

    before do
      allow(MonthlyServiceMetrics).to receive_message_chain(:where, :first_or_initialize) { metrics }
      allow(Service).to receive(:find).with(service.id) { service }
    end

    it_behaves_like 'validating publish token'

    context 'with a valid publish token' do
      before do
        allow(MonthlyServiceMetricsPublishToken).to receive(:valid?).with(token: publish_token, metrics: metrics) { true }
      end

      it 'renders edit template' do
        dispatch
        expect(response).to render_template('monthly_service_metrics/edit')
      end
    end
  end

  describe 'PATCH update' do
    def dispatch
      patch :update, params: { service_id: service.id, year: '2017', month: '06', publish_token: publish_token, metrics: metrics_params }
    end

    let(:publish_token) { 'PuBlIsHtOkEn' }
    let(:metrics_params) { { 'online_transactions' => '1000' } }
    let(:metrics) { instance_double(MonthlyServiceMetrics, :service= => nil, :month= => nil, :attributes= => nil) }
    let(:service) { instance_double(Service, id: '01') }

    before do
      allow(MonthlyServiceMetrics).to receive_message_chain(:where, :first_or_initialize) { metrics }
      allow(Service).to receive(:find).with(service.id) { service }
    end

    it_behaves_like 'validating publish token'

    context 'with valid metrics' do
      before do
        allow(MonthlyServiceMetricsPublishToken).to receive(:valid?).with(token: publish_token, metrics: metrics) { true }
        allow(metrics).to receive(:save) { true }
      end

      it 'renders success template' do
        dispatch
        expect(response).to render_template('monthly_service_metrics/success')
      end
    end

    context 'with invalid metrics' do
      before do
        allow(MonthlyServiceMetricsPublishToken).to receive(:valid?).with(token: publish_token, metrics: metrics) { true }
        allow(metrics).to receive(:save) { false }
      end

      it 'renders edit template' do
        dispatch
        expect(response).to render_template('monthly_service_metrics/edit')
      end
    end
  end
end
