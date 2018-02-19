require 'rails_helper'

RSpec.feature 'viewing department detail pages', type: :feature do
  let(:time_period) { TimePeriod.default }

  specify 'viewing department details' do
    department = FactoryGirl.create(:department, name: 'Department for Transport', natural_key: 'test')
    delivery_organisation = FactoryGirl.create(:delivery_organisation, department: department, name: 'Highways England')
    service1 = FactoryGirl.create(:service, delivery_organisation: delivery_organisation, name: 'Pay the Dartford Crossing charge (Dartcharge)')
    service2 = FactoryGirl.create(:service, delivery_organisation: delivery_organisation, name: 'Register for Dartcharge')

    FactoryGirl.create(:monthly_service_metrics, :published, service: service1, month: time_period.start_month, online_transactions: 4025000, transactions_processed: 1437500)
    FactoryGirl.create(:monthly_service_metrics, :published, service: service2, month: time_period.end_month, online_transactions: 1725000, transactions_processed: 4312500)

    visit view_data_department_path(id: department.natural_key)

    expect(page).to have_content('Detailed data')
    expect(page).to have_content('Department for Transport')
    expect(page).to have_content('2 services')
  end
end
