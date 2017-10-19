require 'rails_helper'

RSpec.feature 'viewing services', type: :feature do
  specify 'viewing a service', cassette: 'viewing-a-service' do
    visit government_metrics_path(group_by: Metrics::Group::Department)

    click_on 'Department for Transport'
    expect(page).to have_content('Service data for Department for Transport')

    click_on 'Driver and Vehicle Licensing Agency'
    expect(page).to have_content('Service data for Driver and Vehicle Licensing Agency')

    click_on 'Apply for a provisional driving license'
    expect(page).to have_content('Information about Apply for a provisional driving license')
    expect(page).to have_content('Service data')
    expect(page).to have_content('2m transactions received')
    expect(page).to have_content('1.74m transactions processed')
  end

  specify 'viewing a service with not-provided data', cassette: 'viewing-a-service' do
    visit government_metrics_path(group_by: Metrics::Group::Department)

    click_on 'Department for Transport'
    expect(page).to have_content('Service data for Department for Transport')

    click_on 'Driver and Vehicle Licensing Agency'
    expect(page).to have_content('Service data for Driver and Vehicle Licensing Agency')

    click_on 'Tax your vehicle'
    expect(page).to have_content('N/A')
    expect(page).to have_content("doesn't receive calls")
  end

  specify 'viewing a service with completeness info', cassette: 'viewing-a-service' do
    visit government_metrics_path(group_by: Metrics::Group::Department)

    click_on 'Department for Transport'
    click_on 'Driver and Vehicle Licensing Agency'
    click_on 'Apply for a provisional driving license'

    expect(page).to have_content('8% of data points complete')
    expect(page).to have_content('Based on incomplete data')
    expect(page).to have_content('Data provided for 1 of 12 months', count: 4)
  end
end
