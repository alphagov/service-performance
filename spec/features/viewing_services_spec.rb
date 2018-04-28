require 'rails_helper'

RSpec.feature 'viewing services', type: :feature do
  let(:time_period) { TimePeriod.default }

  specify 'viewing a service' do
    department = FactoryBot.create(:department, name: 'Department for Transport')
    delivery_organisation = FactoryBot.create(:delivery_organisation, department: department, name: 'Highways England')
    service = FactoryBot.create(:service, delivery_organisation: delivery_organisation, name: 'Pay the Dartford Crossing charge (Dartcharge)')

    FactoryBot.create(:monthly_service_metrics, :published, service: service, month: time_period.start_month, online_transactions: 4025000, transactions_processed: 1437500)
    FactoryBot.create(:monthly_service_metrics, :published, service: service, month: time_period.end_month, online_transactions: 1725000, transactions_processed: 4312500)

    visit view_data_government_metrics_path(group_by: Metrics::GroupBy::Department)

    click_on 'Department for Transport'
    expect(page).to have_content('Department for Transport')

    click_on 'Highways England'
    expect(page).to have_content('Highways England')

    click_on 'Pay the Dartford Crossing charge (Dartcharge)'
    expect(page).to have_content('Pay the Dartford Crossing charge (Dartcharge)')
    expect(page).to have_content('Change time period')
  end

  specify 'viewing a service with not-provided data' do
    department = FactoryBot.create(:department, name: 'Department for Communities and Local Government')
    delivery_organisation = FactoryBot.create(:delivery_organisation, department: department, name: 'Planning Inspectorate')
    service = FactoryBot.create(:service, :calls_received_not_applicable, delivery_organisation: delivery_organisation, name: 'National Infrastructure applications')

    FactoryBot.create(:monthly_service_metrics, :published, service: service, month: time_period.start_month)

    visit view_data_government_metrics_path(group_by: Metrics::GroupBy::Department)

    click_on 'Department for Communities and Local Government'
    expect(page).to have_content('Department for Communities and Local Government')

    click_on 'Planning Inspectorate'
    expect(page).to have_content('Planning Inspectorate')

    click_on 'National Infrastructure applications'
    expect(page).to have_content("doesn't receive calls")
  end
end
