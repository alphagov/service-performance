require 'rails_helper'

RSpec.describe ViewData::TimePeriodController, type: :controller do
  describe "POST update" do
    let(:time_period) {
      instance_double(TimePeriodSettings, range: '12', start_date_month: "", start_date_year: "", end_date_month: "", end_date_year: "", next: "")
    }
    let(:department) { FactoryBot.create(:department, name: 'Department for Environment, Food & Rural Affairs') }
    let(:delivery_organisation) { FactoryBot.create(:delivery_organisation, department: department, name: 'Environment Agency') }
    let(:service) { FactoryBot.create(:service, :transactions_received_not_applicable, :calls_received_not_applicable, delivery_organisation: delivery_organisation, name: 'Flood Information Service') }
    let(:create_metrics) {
      month = YearMonth.new(2016, 1)
      6.times do
        FactoryBot.create(:monthly_service_metrics, :published, service: service, month: month, transactions_processed: 100, transactions_processed_with_intended_outcome: 100)
        month = month.succ
      end
    }

    before do
      allow(time_period).to receive(:valid?)
      create_metrics
    end

    it 'persists time period data to the session for a pre defined range' do
      current_time = Time.local(2018, 1, 23, 12, 0, 0)
      Timecop.freeze(current_time)
      post :update, params: { range: '12', start_date_month: "", start_date_year: "", end_date_month: "", end_date_year: "", next: "" }

      expect(session[:time_period_range]).to eq "2016-12-01 2017-11-30"

      post :update, params: { range: '24', start_date_month: "", start_date_year: "", end_date_month: "", end_date_year: "", next: "" }

      expect(session[:time_period_range]).to eq "2015-12-01 2017-11-30"
      Timecop.return
    end

    it 'persists time period data to the session for a custom range' do
      post :update, params: { range: "custom", start_date_month: "1", start_date_year: "2016", end_date_month: "5", end_date_year: "2017", next: "" }

      expect(session[:time_period_range]).to eq "2016-01-01 2017-05-31"
    end
  end
end
