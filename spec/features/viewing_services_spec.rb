require 'rails_helper'

RSpec.feature 'viewing services', type: :feature do
  let(:time_period) { TimePeriod.default }

  specify 'viewing a service' do
    department = FactoryGirl.create(:department, name: 'Department for Transport')
    delivery_organisation = FactoryGirl.create(:delivery_organisation, department: department, name: 'Highways England')
    service = FactoryGirl.create(:service, delivery_organisation: delivery_organisation, name: 'Pay the Dartford Crossing charge (Dartcharge)')

    FactoryGirl.create(:monthly_service_metrics, :published, service: service, month: time_period.start_month, online_transactions: 4025000, transactions_processed: 1437500)
    FactoryGirl.create(:monthly_service_metrics, :published, service: service, month: time_period.end_month, online_transactions: 1725000, transactions_processed: 4312500)

    visit view_data_government_metrics_path(group_by: Metrics::GroupBy::Department)

    click_on 'Department for Transport'
    expect(page).to have_content('Department for Transport')

    click_on 'Highways England'
    expect(page).to have_content('Highways England')

    click_on 'Pay the Dartford Crossing charge (Dartcharge)'
    expect(page).to have_content('Performance data about Pay the Dartford Crossing charge (Dartcharge)')
    expect(page).to have_content('5.75m')
  end

  specify 'viewing a service with not-provided data' do
    department = FactoryGirl.create(:department, name: 'Department for Communities and Local Government')
    delivery_organisation = FactoryGirl.create(:delivery_organisation, department: department, name: 'Planning Inspectorate')
    service = FactoryGirl.create(:service, :calls_received_not_applicable, delivery_organisation: delivery_organisation, name: 'National Infrastructure applications')

    FactoryGirl.create(:monthly_service_metrics, :published, service: service, month: time_period.start_month)

    visit view_data_government_metrics_path(group_by: Metrics::GroupBy::Department)

    click_on 'Department for Communities and Local Government'
    expect(page).to have_content('Department for Communities and Local Government')

    click_on 'Planning Inspectorate'
    expect(page).to have_content('Planning Inspectorate')

    click_on 'National Infrastructure applications'
    expect(page).to have_content('Not applicable')
    expect(page).to have_content("doesn't receive calls")
  end

  specify 'viewing a service with completeness info' do
    department = FactoryGirl.create(:department, name: 'Department for Environment, Food & Rural Affairs')
    delivery_organisation = FactoryGirl.create(:delivery_organisation, department: department, name: 'Environment Agency')
    service = FactoryGirl.create(:service, :transactions_received_not_applicable, :calls_received_not_applicable, delivery_organisation: delivery_organisation, name: 'Flood Information Service')

    month = time_period.start_month
    6.times do
      FactoryGirl.create(:monthly_service_metrics, :published, service: service, month: month, transactions_processed: 100, transactions_processed_with_intended_outcome: 100)
      month = month.succ
    end

    visit view_data_government_metrics_path(group_by: Metrics::GroupBy::Department)

    click_on 'Department for Environment, Food & Rural Affairs'
    click_on 'Environment Agency'
    click_on 'Flood Information Service'

    expect(page).to have_content('50% of data provided')
    expect(page).to have_content('Based on incomplete data')
    expect(page).to have_content('Data provided for 6 of 12 months')
  end
end
