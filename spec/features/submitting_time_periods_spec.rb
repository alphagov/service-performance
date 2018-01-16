require 'rails_helper'

RSpec.feature 'submitting time period data' do
  let(:time_period) { TimePeriod.default }
  let(:department) { FactoryGirl.create(:department, name: 'Department for Environment, Food & Rural Affairs') }
  let(:delivery_organisation) { FactoryGirl.create(:delivery_organisation, department: department, name: 'Environment Agency') }
  let(:service) { FactoryGirl.create(:service, :transactions_received_not_applicable, :calls_received_not_applicable, delivery_organisation: delivery_organisation, name: 'Flood Information Service') }
  let(:create_metrics) {
    month = time_period.start_month
    6.times do
      FactoryGirl.create(:monthly_service_metrics, :published, service: service, month: month, transactions_processed: 100, transactions_processed_with_intended_outcome: 100)
      month = month.succ
    end
  }
  specify 'submitting time data via a referer' do
    create_metrics
    visit view_data_government_metrics_path(group_by: Metrics::GroupBy::Service)
    click_link('Change time period')

    expect(page).to have_text('What time period do you want to view?')

    choose('range_12')
    click_button 'Change dates'

    expect(page).to have_current_path('/performance-data/government/metrics/service')
    expect(page).to have_text('Find service')
  end

  specify 'submitting time data via no referer' do
    create_metrics

    visit view_data_time_period_path
    expect(page).to have_text('What time period do you want to view?')

    choose('range_12')
    click_button 'Change dates'

    expect(page).to have_current_path(view_data_government_metrics_path(group_by: Metrics::GroupBy::Department))
  end

  specify 'submitting time data with an invalid path' do
    create_metrics

    referer = 'http://example.com/malicious'
    Capybara.current_session.driver.header 'Referer', referer

    visit view_data_time_period_path
    expect(page).to have_text('What time period do you want to view?')

    Capybara.current_session.driver.header 'Referer', nil

    choose('range_12')
    click_button 'Change dates'

    expect(page).to have_current_path(view_data_government_metrics_path(group_by: Metrics::GroupBy::Department))
  end
end
