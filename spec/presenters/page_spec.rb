require 'rails_helper'

RSpec.describe Page, type: :presenter do
  let(:controller) { instance_double(ActionController::Base) }
  subject(:page) { Page.new(controller) }

  describe '#title' do
    it 'prepends title, if set' do
      page.title = 'My Fancy Title'
      expect(page.title).to eq('My Fancy Title - Service Performance')
    end

    it 'returns the default, if not set' do
      page.title = nil
      expect(page.title).to eq('Service Performance')
    end
  end

  describe '#path' do
    it 'returns the request path from the controller' do
      request = double(:request, path: '/example')
      allow(controller).to receive(:request) { request }

      expect(page.path).to eq('/example')
    end
  end
end
