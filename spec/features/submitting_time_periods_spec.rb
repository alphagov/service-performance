require 'rails_helper'

RSpec.feature 'submitting time period data' do
  before(:all) do
    Capybara.ignore_hidden_elements = false
  end
  after(:all) do
    Capybara.ignore_hidden_elements = true
  end

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

  specify 'via a referer' do
    create_metrics
    visit view_data_government_metrics_path(group_by: Metrics::GroupBy::Service)
    click_link('Change time period')

    expect(page).to have_text('What time period do you want to view?')

    choose('range_12')
    click_button 'Change dates'

    expect(page).to have_current_path('/performance-data/government/metrics/service')
    expect(page).to have_text('Find service')
  end

  specify 'via no referer' do
    create_metrics

    visit view_data_time_period_path
    expect(page).to have_text('What time period do you want to view?')

    choose('range_12')
    click_button 'Change dates'

    expect(page).to have_current_path(view_data_government_metrics_path(group_by: Metrics::GroupBy::Department))
  end

  specify 'with an invalid path' do
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

  specify 'with invalid month value' do
    visit view_data_time_period_path

    choose('range_custom')

    fill_in 'start_date_month', with: '122'

    click_button 'Change dates'

    expect(page).to have_content('Must be between 1 - 12')
  end

  specify 'with a 0 spaced month value' do
    visit view_data_time_period_path

    choose('range_custom')

    fill_in 'start_date_month', with: '02'
    fill_in 'end_date_month', with: '02'

    click_button 'Change dates'

    expect(page).not_to have_content('Must be between 1 - 12')
  end

  specify 'with a month value that is not 0 spaced' do
    visit view_data_time_period_path

    choose('range_custom')

    fill_in 'start_date_month', with: '2'
    fill_in 'end_date_month', with: '2'

    click_button 'Change dates'

    expect(page).not_to have_content('Must be between 1 - 12')
  end

  specify 'with a month value between 10-12' do
    visit view_data_time_period_path

    choose('range_custom')

    fill_in 'start_date_month', with: '12'
    fill_in 'end_date_month', with: '12'

    click_button 'Change dates'

    expect(page).not_to have_content('Must be between 1 - 12')
  end

  specify 'with a year value greater than 4 digits' do
    visit view_data_time_period_path

    choose('range_custom')

    fill_in 'start_date_year', with: '20017'

    click_button 'Change dates'

    expect(page).to have_content(' Invalid year format. Must be: YYYY')
  end

  specify 'year value that is before 1900' do
    visit view_data_time_period_path

    choose('range_custom')

    fill_in 'start_date_year', with: '1800'

    click_button 'Change dates'

    expect(page).to have_content('Must be after 1900')
  end

  specify 'with an end date that is before a start date' do
    visit view_data_time_period_path

    choose('range_custom')

    fill_in 'start_date_month', with: '1'
    fill_in 'start_date_year', with: '2017'

    fill_in 'end_date_month', with: '1'
    fill_in 'end_date_year', with: '2016'

    click_button 'Change dates'

    expect(page).to have_content("End date can't be before start date")
  end

  specify 'with an end date in the future' do
    current_time = Time.local(2018, 1, 18, 12, 0, 0)
    Timecop.freeze(current_time)

    visit view_data_time_period_path

    choose('range_custom')

    fill_in 'start_date_month', with: '1'
    fill_in 'start_date_year', with: '2017'

    fill_in 'end_date_month', with: '1'
    fill_in 'end_date_year', with: '2099'

    click_button 'Change dates'

    expect(page).to have_content("End date can't be in the future")
    Timecop.return
  end

  specify 'when Custom date range radio button is selected but custom date fields are empty' do
    visit view_data_time_period_path

    choose('range_custom')

    fill_in 'start_date_month', with: ''
    fill_in 'start_date_year', with: '2016'

    fill_in 'end_date_month', with: '2'
    fill_in 'end_date_year', with: ''

    click_button 'Change dates'

    expect(page).to have_content("Start date month: can't be blank")
    expect(page).to have_content("End date year: can't be blank")
    expect(page).not_to have_content("Range: can't be blank")
  end

  specify "when Custom date range isn't selected, a set range option must be submitted" do
  end
end
