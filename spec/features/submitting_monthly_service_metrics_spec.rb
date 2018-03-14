require 'rails_helper'

RSpec.feature 'submitting monthly service metrics' do
  let(:service) { FactoryGirl.create(:service, name: 'The Submitting Data Service') }
  let(:publish_token) { MonthlyServiceMetricsPublishToken.generate(service: service, month: YearMonth.new(2017, 9)) }
  specify 'submitting metrics' do
    visit_metrics_path

    expect(page).to have_text('Provide data for The Submitting Data Service – 1 to 30 September 2017')
    expect(page).to have_text('Your data will be published on 1 November 2017.')

    within_fieldset('Number of transactions received, split by channel') do
      fill_in 'Online', with: '18,000'
      fill_in 'Phone', with: '15,000'
      fill_in 'Paper', with: '16,000'
      fill_in 'Face-to-face', with: '15,000'
      fill_in 'Transactions received through this channel', with: '14,000'
    end

    within_fieldset('Number of transactions processed') do
      fill_in 'Transactions processed', with: '13,000'
    end

    within_fieldset('Number of transactions ending in the user’s intended outcome') do
      fill_in "Transactions processed with the user's intended outcome", with: '12,000'
    end

    within_fieldset('Total number of phone calls received') do
      fill_in 'Calls received', with: '20,000'
    end

    within_fieldset('Number of phone calls received, split by reasons for calling') do
      fill_in 'To perform a transaction', with: '15,000'
      fill_in 'To get information', with: '1000'
      fill_in 'To chase progress', with: '1500'
      fill_in 'To challenge a decision', with: '1500'
      fill_in 'Number of telephone calls for this reason', with: '1000'
    end

    click_button 'Submit'

    metrics = MonthlyServiceMetrics.last
    expect(metrics.service).to eq(service)
    expect(metrics.month).to eq(YearMonth.new(2017, 9))
    expect(metrics.online_transactions).to eq(18000)
    expect(metrics.phone_transactions).to eq(15000)
    expect(metrics.paper_transactions).to eq(16000)
    expect(metrics.face_to_face_transactions).to eq(15000)
    expect(metrics.other_transactions).to eq(14000)
    expect(metrics.transactions_processed).to eq(13000)
    expect(metrics.transactions_processed_with_intended_outcome).to eq(12000)
    expect(metrics.calls_received).to eq(20000)
    expect(metrics.calls_received_perform_transaction).to eq(15000)
    expect(metrics.calls_received_get_information).to eq(1000)
    expect(metrics.calls_received_chase_progress).to eq(1500)
    expect(metrics.calls_received_challenge_decision).to eq(1500)
    expect(metrics.calls_received_other).to eq(1000)

    expect(page).to have_text('Upload successful')
    expect(page).to have_text('Thank you for providing your monthly data. It will be published on 1 November 2017.')
    expect(page).to have_text('You will next be asked to provide data on 1 November.')
  end

  specify "submitting invalid 'Transactions processed with the user's intended outcome' metrics" do
    visit_metrics_path

    fill_in "Transactions processed", with: "100"
    fill_in "Transactions processed with the user's intended outcome", with: "120"

    click_button 'Submit'

    expect(page).to have_content("Transactions processed with intended outcome must be less than or equal to transactions processed")
  end

  specify "submitting invalid 'Number of calls received... to perform a transaction' metrics" do
    visit_metrics_path

    within_fieldset('Number of transactions received, split by channel') do
      fill_in 'Phone', with: '2'
    end

    within_fieldset('Number of phone calls received, split by reasons for calling') do
      fill_in 'To perform a transaction', with: '30'
    end

    click_button 'Submit'

    expect(page).to have_content("This should be the same as the 'Number of transactions received, split by channel (phone)")
  end

  specify "submitting invalid 'Total number of calls received' metrics" do
    visit_metrics_path

    within_fieldset('Total number of phone calls received') do
      fill_in 'Calls received', with: '100'
    end

    within_fieldset('Number of phone calls received, split by reasons for calling') do
      fill_in 'To perform a transaction', with: '10'
      fill_in 'To get information', with: '2'
      fill_in 'To chase progress', with: ''
      fill_in 'To challenge a decision', with: '3'
      fill_in 'Number of telephone calls for this reason', with: ''
    end

    click_button 'Submit'

    expect(page).to have_content("Calls received should be the sum of the fields within 'Number of phone calls received, split by reasons for calling'")
  end

  specify "submitting 'Total number of calls received' metrics with blank calls received total" do
    visit_metrics_path

    within_fieldset('Total number of phone calls received') do
      fill_in 'Calls received', with: ''
    end

    within_fieldset('Number of phone calls received, split by reasons for calling') do
      fill_in 'To perform a transaction', with: '10'
      fill_in 'To get information', with: '2'
      fill_in 'To chase progress', with: ''
      fill_in 'To challenge a decision', with: '3'
      fill_in 'Number of telephone calls for this reason', with: ''
    end

    click_button 'Submit'

    expect(page).to have_content("Calls received should be the sum of the fields within 'Number of phone calls received, split by reasons for calling'")
  end

  specify "submitting 'Total number of calls received' metrics with blank reasons" do
    visit_metrics_path

    within_fieldset('Total number of phone calls received') do
      fill_in 'Calls received', with: '100'
    end

    within_fieldset('Number of phone calls received, split by reasons for calling') do
      fill_in 'To perform a transaction', with: ''
      fill_in 'To get information', with: ''
      fill_in 'To chase progress', with: ''
      fill_in 'To challenge a decision', with: ''
      fill_in 'Number of telephone calls for this reason', with: ''
    end

    click_button 'Submit'

    expect(page).not_to have_content("Calls received should be the sum of the fields within 'Number of phone calls received, split by reasons for calling'")
  end

  specify "Titles are not shown for non-applicable calls" do
    svc = FactoryGirl.create(:service, name: 'No calls service', calls_received_applicable: false)
    token = MonthlyServiceMetricsPublishToken.generate(service: svc, month: YearMonth.new(2017, 9))

    visit publish_service_metrics_path(service_id: svc, year: '2017', month: '09', publish_token: token)
    expect(page).not_to have_content('Total number of phone calls received')
    expect(page).to have_content('Number of phone calls received, split by reasons for calling')
  end

  specify "Titles are not shown for other when no-call-other" do
    svc = FactoryGirl.create(:service,
      name: 'No calls service',
      calls_received_perform_transaction_applicable: false,
      calls_received_get_information_applicable: false,
      calls_received_chase_progress_applicable: false,
      calls_received_challenge_decision_applicable: false,
      calls_received_other_applicable: false)
    token = MonthlyServiceMetricsPublishToken.generate(service: svc, month: YearMonth.new(2017, 9))

    visit publish_service_metrics_path(service_id: svc, year: '2017', month: '09', publish_token: token)
    expect(page).to have_content('Total number of phone calls received')
    expect(page).not_to have_content('Number of phone calls received, split by reasons for calling')
  end

  specify "No call labels when no calls are applicable" do
    svc = FactoryGirl.create(:service,
      name: 'No calls service',
      calls_received_applicable: false,
      calls_received_perform_transaction_applicable: false,
      calls_received_get_information_applicable: false,
      calls_received_chase_progress_applicable: false,
      calls_received_challenge_decision_applicable: false,
      calls_received_other_applicable: false)
    token = MonthlyServiceMetricsPublishToken.generate(service: svc, month: YearMonth.new(2017, 9))

    visit publish_service_metrics_path(service_id: svc, year: '2017', month: '09', publish_token: token)
    expect(page).not_to have_content('Total number of phone calls received')
    expect(page).not_to have_content('Number of phone calls received, split by reasons for calling')
  end

  private

  def visit_metrics_path
    visit publish_service_metrics_path(service_id: service, year: '2017', month: '09', publish_token: publish_token)
  end

  def within_fieldset(text, &block)
    fieldsets = all('fieldset').select do |fieldset|
      fieldset.first('h2', text: text)
    end

    case fieldsets.size
    when 1
      within(fieldsets.first, &block)
    when 0
      raise 'No fieldset found, with heading "%s"' % [text]
    else
      raise 'Ambiguous fieldsets, %d fieldsets found with heading "%s"' % [fieldsets.size, text]
    end
  end
end
