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

    context 'with breadcrumbs' do
      let(:crumb) { double(:crumb, name: 'Crumbs', url: 'https://example.com') }
      let(:page_breadcrumbs) { [crumb] }

      it 'renders a list of breadcrumbs' do
        expect(breadcrumbs).to have_selector('div.breadcrumbs > ol > li > a')
        expect(breadcrumbs).to have_link(text: 'Crumbs', href: 'https://example.com')
      end
    end
  end

end
