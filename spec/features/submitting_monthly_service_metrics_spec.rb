require 'rails_helper'

RSpec.feature 'submitting monthly service metrics' do
  specify 'submitting metrics' do
    service = FactoryGirl.create(:service)
    publish_token = MonthlyServiceMetricsPublishToken.generate(service: service, month: YearMonth.new(2017, 9))

    visit publish_service_metrics_path(service_id: service, year: '2017', month: '09', publish_token: publish_token)

    expect(page).to have_text('Provide data for the period 1 to 30 September 2017')
    expect(page).to have_text('Your data will be published on 1 November 2017.')

    within_fieldset('Number of transactions received, split by channel') do
      fill_in 'Online', with: '18,000'
      fill_in 'Phone', with: '17,000'
      fill_in 'Paper', with: '16,000'
      fill_in 'Face-to-face', with: '15,000'
      fill_in 'Other', with: '14,000'
    end

    within_fieldset('Number of transactions processed') do
      fill_in 'Transactions processed', with: '13,000'
    end

    within_fieldset('Number of transactions ending in the user’s intended outcome') do
      fill_in "Transactions processed with the user's intended outcome", with: '12,000'
    end

    within_fieldset('Total number of phone calls received') do
      fill_in 'Calls received', with: '11,000'
    end

    within_fieldset('Number of phone calls received, split by reasons for calling') do
      fill_in 'to perform a transaction', with: '6,000'
      fill_in 'to get information', with: '10,000'
      fill_in 'to chase progress', with: '9,000'
      fill_in 'to challenge a decision', with: '8,000'
      fill_in 'Other', with: '7,000'
    end

    click_button 'Submit'

    metrics = MonthlyServiceMetrics.last
    expect(metrics.service).to eq(service)
    expect(metrics.month).to eq(YearMonth.new(2017, 9))
    expect(metrics.online_transactions).to eq(18000)
    expect(metrics.phone_transactions).to eq(17000)
    expect(metrics.paper_transactions).to eq(16000)
    expect(metrics.face_to_face_transactions).to eq(15000)
    expect(metrics.other_transactions).to eq(14000)
    expect(metrics.transactions_with_outcome).to eq(13000)
    expect(metrics.transactions_with_intended_outcome).to eq(12000)
    expect(metrics.calls_received).to eq(11000)
    expect(metrics.calls_received_perform_transaction).to eq(6000)
    expect(metrics.calls_received_get_information).to eq(10000)
    expect(metrics.calls_received_chase_progress).to eq(9000)
    expect(metrics.calls_received_challenge_decision).to eq(8000)
    expect(metrics.calls_received_other).to eq(7000)

    expect(page).to have_text('Upload successful')
    expect(page).to have_text('Thank you for providing your monthly data. It will be published on 1 November 2017.')
    expect(page).to have_text('You will next be asked to provide data on 1 October.')
  end

  private

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
