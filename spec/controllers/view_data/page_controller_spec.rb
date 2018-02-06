require 'rails_helper'

RSpec.describe ViewData::PagesController, type: :controller do
  describe 'GET show' do
    let(:page) { controller.send(:page) }

    it 'sets the page title to the service page' do
      get :homepage
      expect(page.title).to match(/\AService Performance/)
    end

    it 'has a cookie page' do
      get :cookies
      expect(controller).to have_rendered('view_data/pages/cookies')
    end

    it 'has a privacy policy page' do
      get :privacy
      expect(controller).to have_rendered('view_data/pages/privacy')
    end

    it 'has a terms and conditions page' do
      get :terms
      expect(controller).to have_rendered('view_data/pages/terms')
    end
  end
end
