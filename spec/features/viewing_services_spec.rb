require 'rails_helper'

RSpec.feature 'viewing services', type: :feature do
  specify 'viewing a service', cassette: 'viewing-a-service' do
    visit government_metrics_path(group_by: Metrics::Group::Department)

    click_on 'Department for Transport'
    expect(page).to have_content('Service data for Department for Transport')

    click_on 'Highways England'
    expect(page).to have_content('Service data for Highways England')

    click_on 'Pay the Dartford Crossing charge (Dartcharge)'
    expect(page).to have_content('Information about Pay the Dartford Crossing charge (Dartcharge)')
    expect(page).to have_content('Service data')
    expect(page).to have_content('5.75m transactions received')
    expect(page).to have_content('5.75m transactions processed')
  end

  specify 'viewing a service with not-provided data', cassette: 'viewing-a-service' do
    visit government_metrics_path(group_by: Metrics::Group::Department)

    click_on 'Department for Communities and Local Government'
    expect(page).to have_content('Service data for Department for Communities and Local Government')

    click_on 'Planning Inspectorate'
    expect(page).to have_content('Service data for Planning Inspectorate')

    click_on 'National Infrastructure applications'
    expect(page).to have_content('Not applicable')
    expect(page).to have_content("doesn't receive calls")
  end

  specify 'viewing a service with completeness info', cassette: 'viewing-a-service' do
    pending 'unification of gsd-view-data & gsd-api'
    visit government_metrics_path(group_by: Metrics::Group::Department)

    click_on 'Department for Environment, Food & Rural Affairs'
    click_on 'Environment Agency'
    click_on 'Flood Information Service'

    expect(page).to have_content('50% of data points complete')
    expect(page).to have_content('Based on incomplete data')
    expect(page).to have_content('Data provided for 6 of 12 months', count: 4)
  end
end
