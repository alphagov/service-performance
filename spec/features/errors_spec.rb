require 'rails_helper'

RSpec.feature 'getting error pages', type: :feature do
  specify 'page not found' do
    visit "/not-existent-page"
    expect(page).to have_content('Page not found')
    expect(page).to have_content('If you entered a web address please check it was correct.')
  end

  specify 'internal server error' do
    visit "/500"
    expect(page).to have_content("We're sorry, but something went wrong.")
  end
end
