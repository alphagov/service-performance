require 'rails_helper'

RSpec.describe BreadcrumbsHelper, type: :helper do

  describe '#breadcrumbs' do
    let(:page) { instance_double(Page, breadcrumbs: page_breadcrumbs) }

    context 'with no breadcrumbs' do
      let(:page_breadcrumbs) { [] }

      it 'renders nothing' do
        expect(breadcrumbs).to eq('')
      end
    end

    context 'with one breadcrumb' do
      let(:page_breadcrumbs) { [double(:crumb)] }

      it 'renders nothing' do
        expect(breadcrumbs).to eq('')
      end
    end

    context 'with multiple breadcrumbs' do
      let(:crumb_1) { double(:crumb, name: 'Crumb 1', url: 'https://example.com') }
      let(:crumb_2) { double(:crumb, name: 'Crumb 2', url: 'https://example.com') }
      let(:page_breadcrumbs) { [crumb_1, crumb_2] }

      it 'renders a list of breadcrumbs' do
        expect(breadcrumbs).to have_selector('.hierarchical-breadcrumbs > nav > a')
        expect(breadcrumbs).to have_link(text: 'Crumb 1', href: 'https://example.com')

        expect(breadcrumbs).to have_selector('.hierarchical-breadcrumbs > nav > ul > li > a')
        expect(breadcrumbs).to have_link(text: 'Crumb 2', href: 'https://example.com')
      end
    end
  end

end
