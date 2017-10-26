require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe 'GET show' do
    let(:page) { controller.send(:page) }

    it 'sets the page title to the service page' do
      get :homepage
      expect(page.title).to match(/\AService Performance/)
    end
  end
end
