require 'rails_helper'

RSpec.describe MetricItemHelper, type: :helper do
  describe '#metric_item' do
    let(:identifier) { 'transactions-received' }

    it 'wraps the content in an <li>' do
      output = metric_item(identifier, 0) do
        "<p>Content</p>".html_safe
      end

      expect(output).to have_selector('li p')
    end

    it 'passes html options to the content tag' do
      output = metric_item(identifier, 0, html: { class: 'optional-class' }) {}
      expect(output).to have_selector('li.optional-class')
    end

    it 'includes the identifier as a data attribute' do
      output = metric_item(identifier, 0) {}
      expect(output).to have_selector('li[data-metric-item-identifier="transactions-received"]')
    end

    it 'includes the description as a data attribute' do
      output = metric_item(identifier, 0) do |item|
        item.description do
          '<strong>transactions-received</strong> description'
        end
      end

      escaped_description = '&lt;strong&gt;transactions-received&lt;/strong&gt; description'
      expect(output).to have_selector(%{li[data-metric-item-description="#{escaped_description}"]})
    end

    it 'adds a sampled class, if sampled' do
      output = metric_item(identifier, 0, sampled: true) {}
      expect(output).to have_selector('li.sampled')
    end
  end
end
