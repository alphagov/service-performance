require 'rails_helper'

RSpec.feature 'viewing metrics', type: :feature do
  context 'sorting metrics' do
    with_conditional_javascript do
      it 'allows sorting of metric groups', cassette: 'viewing-metrics-sorting-metrics' do
        visit government_metrics_path(group_by: Metrics::Group::Department)

        expect(page).to have_text('Service data for UK government')

        expect(metric_groups(:name)).to eq([
          ['Department for Business, Energy & Industrial Strategy'],
          ['Department for Education'],
          ['Department for Environment Food & Rural Affairs'],
          ['Department for Transport'],
          ['Department of Health'],
          ['HM Revenue & Customs'],
          ['Ministry of Justice'],
        ])

        select 'transactions received', from: 'Sort by'
        click_on 'Apply' unless javascript_enabled

        expect(metric_groups(:name, :transactions_received_total)).to eq([
          ['HM Revenue & Customs',                                          '0'],
          ['Department for Business, Energy & Industrial Strategy',         '0'],
          ['Department for Environment Food & Rural Affairs',         '3000039'],
          ['Department for Education',                               '13000475'],
          ['Department of Health',                                   '18132669'],
          ['Department for Transport',                              '118679511'],
          ['Ministry of Justice',                                   '593254687'],
        ])

        if javascript_enabled
          find('label', text: 'High to Low').click
        else
          choose 'High to Low'
        end
        click_on 'Apply' unless javascript_enabled

        expect(metric_groups(:name, :transactions_received_total)).to eq([
          ['Ministry of Justice',                                   '593254687'],
          ['Department for Transport',                              '118679511'],
          ['Department of Health',                                   '18132669'],
          ['Department for Education',                               '13000475'],
          ['Department for Environment Food & Rural Affairs',         '3000039'],
          ['Department for Business, Energy & Industrial Strategy',         '0'],
          ['HM Revenue & Customs',                                          '0'],
        ])
      end
    end
  end

  private

  def metric_groups(*attrs)
    attributes = ->(metric_group) { attrs.map {|attribute| metric_group.send(attribute) } }

    all('.metric-group', count: 7)
      .map { |element| MetricGroup.new(element) }
      .collect(&attributes)
  end

  class MetricGroup
    def initialize(element)
      @element = element
    end

    attr_reader :element

    def name
      element.find('h2').text
    end

    def transactions_received_total
      element.find('.m-metric__transactions-received .m-metric-headline data')[:value]
    end
  end
end
