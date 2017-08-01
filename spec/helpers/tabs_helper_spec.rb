require 'rails_helper'

RSpec.describe TabsHelper, type: :helper do

  describe '#tabs' do
    let(:page) { instance_double(Page, path: '/') }

    it 'renders nothing when no tabs are added' do
      output = tabs(current_page: page) {}
      expect(output).to be_empty
    end

    it 'renders tabs with their links' do
      output = tabs(current_page: page) do |tabs|
        tabs.link_to 'Example 1', '/example1'
        tabs.link_to 'Example 2', '/example2'
      end

      expect(output).to have_selector('nav.o-tabs ol')
      expect(output).to have_selector('nav.o-tabs ol li.m-tab-item a.m-tab-link[href="/example1"]', text: 'Example 1')
      expect(output).to have_selector('nav.o-tabs ol li.m-tab-item a.m-tab-link[href="/example2"]', text: 'Example 2')
    end

    it 'marks the tab as selected if the path matches' do
      allow(page).to receive(:path) { '/example1' }

      output = tabs(current_page: page) do |tabs|
        tabs.link_to 'Example 1', '/example1'
        tabs.link_to 'Example 2', '/example2'
      end

      expect(output).to have_selector('li.m-tab-item__selected a.m-tab-link[href="/example1"]', text: 'Example 1')
      expect(output).to have_selector('li a.m-tab-link[href="/example2"]', text: 'Example 2')
    end

    it 'marks the tab as selected if the path of the URL matches' do
      allow(page).to receive(:path) { '/example1' }

      output = tabs(current_page: page) do |tabs|
        tabs.link_to 'Example 1', 'http://example.com/example1'
        tabs.link_to 'Example 2', 'http://example.com/example2'
      end

      expect(output).to have_selector('li.m-tab-item__selected a.m-tab-link[href="http://example.com/example1"]', text: 'Example 1')
      expect(output).to have_selector('li a.m-tab-link[href="http://example.com/example2"]', text: 'Example 2')
    end
  end

  describe '#tab_name' do
    it "returns the name, when there's no count" do
      expect(tab_name('Tabz')).to eq('Tabz')
    end

    it 'returns the name, and count (wrapped in a span)' do
      output = tab_name('Tabz', count: 10)

      expect(output).to have_text('Tabz')
      expect(output).to have_selector('span.count', text: '(10)')
    end
  end

end
