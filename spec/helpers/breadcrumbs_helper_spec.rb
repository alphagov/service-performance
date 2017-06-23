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
        expect(breadcrumbs).to have_selector('nav.breadcrumbs > ol > li.breadcrumbs__item > a')
        expect(breadcrumbs).to have_link(text: 'Crumbs', href: 'https://example.com')
      end

      it "adds 'breadcrumbs-inverse' class if inverse is true" do
        expect(breadcrumbs(inverse: true)).to have_selector('nav.breadcrumbs--inverse')
      end

      it 'marks-up the list with accessiblity metadata' do
        output = breadcrumbs

        expect(breadcrumbs).to have_selector('nav[aria-label="Breadcrumbs"]')
        expect(breadcrumbs).to have_selector('ol[itemscope=itemscope][itemtype="http://schema.org/BreadcrumbList"]')
        expect(breadcrumbs).to have_selector('li[itemscope=itemscope][itemprop="itemListElement"][itemtype="http://schema.org/ListItem"]')
        expect(breadcrumbs).to have_selector('a[itemprop="item"]')
        expect(breadcrumbs).to have_selector('span[itemprop="name"]')
      end
    end
  end

end
