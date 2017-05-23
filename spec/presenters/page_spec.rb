require 'rails_helper'

RSpec.describe Page, type: :presenter do
  subject(:page) { Page.new }

  describe '#title' do
    it 'prepends title, if set' do
      page.title = 'My Fancy Title'
      expect(page.title).to eq('My Fancy Title - Cross-Government Service Data')
    end

    it 'returns the default, if not set' do
      page.title = nil
      expect(page.title).to eq('Cross-Government Service Data')
    end
  end

end
