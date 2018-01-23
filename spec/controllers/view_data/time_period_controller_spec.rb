require 'rails_helper'

RSpec.describe ViewData::TimePeriodController, type: :controller do
  describe "POST update" do
    let(:time_period) { instance_double(TimePeriodSettings, range: '12', start_date_month: "", start_date_year: "", end_date_month: "", end_date_year: "", next: "") }

    before do
      allow(time_period).to receive(:valid?)
    end

    it 'persists time period data to the session for a pre defined range' do
      current_time = Time.local(2018, 1, 23, 12, 0, 0)
      Timecop.freeze(current_time)
      post :update, params: { range: '12', start_date_month: "", start_date_year: "", end_date_month: "", end_date_year: "", next: "" }

      expect(session[:time_period_range]).to eq "2017-01-01 2018-01-31"

      post :update, params: { range: '24', start_date_month: "", start_date_year: "", end_date_month: "", end_date_year: "", next: "" }

      expect(session[:time_period_range]).to eq "2016-01-01 2018-01-31"
      Timecop.return
    end

    it 'persists time period data to the session for a custom range' do
      post :update, params: { range: "custom", start_date_month: "1", start_date_year: "2016", end_date_month: "5", end_date_year: "2017", next: "" }

      expect(session[:time_period_range]).to eq "2016-01-01 2017-05-31"
    end
  end
end
