require 'rails_helper'

RSpec.describe ViewData::ServicesController, type: :controller do
  describe 'GET show' do
    let(:time_period) {
      instance_double(TimePeriodSettings, range: '12', start_date_month: "", start_date_year: "", end_date_month: "", end_date_year: "", next: "")
    }
    let(:department) { FactoryGirl.create(:department, name: 'Department for Environment, Food & Rural Affairs', natural_key: '001') }
    let(:delivery_organisation) { FactoryGirl.create(:delivery_organisation, department: department, name: 'Environment Agency', natural_key: '003') }
    let(:service) { FactoryGirl.create(:service, :transactions_received_not_applicable, :calls_received_not_applicable, delivery_organisation: delivery_organisation, name: 'Flood Information Service', natural_key: '2') }
    let(:create_metrics) {
      month = YearMonth.new(2016, 1)
      6.times do
        FactoryGirl.create(:monthly_service_metrics, :published, service: service, month: month, transactions_processed: 200, transactions_processed_accepted: 100, transactions_processed_rejected: 100)
        month = month.succ
      end
    }
    let(:page) { controller.send(:page) }

    before do
      allow(time_period).to receive(:valid?)
      create_metrics
    end

    it 'sets the page title to the service page' do
      get :show, params: { id: '2' }

      expect(page.title).to match(/\AFlood Information Service/)
    end

    it 'sets the breadcrumbs' do
      get :show, params: { id: '2' }

      expect(page.breadcrumbs.map { |crumb| [crumb.name, crumb.url] }).to eq([
        ['UK Government', view_data_government_metrics_path],
        ['Department for Environment, Food & Rural Affairs', view_data_department_metrics_path(department_id: '001')],
        ['Environment Agency', view_data_delivery_organisation_metrics_path(delivery_organisation_id: '003')],
        ['Flood Information Service', nil],
      ])
    end
  end
end
