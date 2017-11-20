require 'rails_helper'

RSpec.feature 'viewing metrics', type: :feature do
  context 'sorting metrics' do
    with_conditional_javascript do
      it 'allows sorting of metric groups', cassette: 'viewing-metrics-sorting-metrics' do
        visit view_data_government_metrics_path(group_by: Metrics::Group::Department)

        expect(page).to have_text('Service data for UK government')

        expect(metric_groups(:name)).to eq([
          ["Total for UK government"],
          ["Department for Business, Energy & Industrial Strategy"],
          ["Department for Communities and Local Government"],
          ["Department for Education"],
          ["Department for Environment, Food & Rural Affairs"],
          ["Department for Transport"],
          ["Department for Work and Pensions"],
          ["Ministry of Justice"]
        ])

        select 'transactions received', from: 'Sort by'
        click_on 'Apply' unless javascript_enabled

        all('a', text: /\AOpen\z/).each(&:click) if javascript_enabled

        expect(metric_groups(:name, :transactions_received_total)).to eq([
          ["Total for UK government", "26592298"],
          ["Department for Environment, Food & Rural Affairs", "12537482"],
          ["Department for Transport", "5747785"],
          ["Department for Business, Energy & Industrial Strategy", "4436917"],
          ["Department for Work and Pensions", "3709191"],
          ["Department for Education", "91223"],
          ["Ministry of Justice", "58140"],
          ["Department for Communities and Local Government", "11560"],
        ])

        if javascript_enabled
          find('label', text: 'Low to High').click
        else
          choose 'Low to High'
        end
        click_on 'Apply' unless javascript_enabled

        all('a', text: /\AOpen\z/).each(&:click) if javascript_enabled

        expect(metric_groups(:name, :transactions_received_total)).to eq([
          ["Department for Communities and Local Government", "11560"],
          ["Ministry of Justice", "58140"],
          ["Department for Education", "91223"],
          ["Department for Work and Pensions", "3709191"],
          ["Department for Business, Energy & Industrial Strategy", "4436917"],
          ["Department for Transport", "5747785"],
          ["Department for Environment, Food & Rural Affairs", "12537482"],
          ["Total for UK government", "26592298"],
        ])
      end
    end

    it 'collapses metric groups, when sorting by attributes (other than name)', cassette: 'viewing-metrics-collapsing-metric-groups', js: true do
      visit view_data_government_metrics_path(group_by: Metrics::Group::Department, order_by: "name")

      expect(page).to have_selector('.m-metric-group', count: 8)
      expect(page).to have_selector('.m-metric-group[data-behaviour~="m-metric-group__collapsible"]', count: 0)
      expect(page).to have_selector('.completeness', count: 8)

      select 'transactions received', from: 'Sort by'
      expect(page).to have_selector('.m-metric-group[data-behaviour~="m-metric-group__collapsible"]', count: 8)
    end

    it 'gov totals show how many services', cassette: 'viewing-metrics-collapsing-metric-groups', js: true do
      visit view_data_government_metrics_path(group_by: Metrics::Group::Department, order_by: "name")
      expect(page).to have_content('based on 34 services', count: 1)
    end

    it 'collapsed totals show how many services', cassette: 'viewing-metrics-collapsing-metric-groups', js: true do
      visit view_data_government_metrics_path(group_by: Metrics::Group::Department, order_by: "transactions-received")
      expect(page).to have_content('based on 34 services', count: 1)
    end
  end

  context 'sometimes we have unspecified calls received', cassette: 'viewing-metrics-sorting-metrics' do
    it 'sometimes has unspecified values, sometimes not' do
      visit view_data_government_metrics_path(group_by: Metrics::Group::Department)

      expect(metric_groups(:name, :calls_received_unspecified)).to eq([
          ['Total for UK government', '995190'],
          ['Department for Business, Energy & Industrial Strategy', '171'],
          ["Department for Communities and Local Government", nil],
          ['Department for Education', nil],
          ['Department for Environment, Food & Rural Affairs', '213775'],
          ['Department for Transport', '313749'],
          ['Department for Work and Pensions', '467495'],
          ['Ministry of Justice', nil],
      ])
    end
  end

  private

  def metric_groups(*attrs)
    attributes = ->(metric_group) { attrs.map { |attribute| metric_group.send(attribute) } }

    all('.m-metric-group')
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
      begin
        element.find('.m-metric__transactions-received .m-metric-headline data', visible: false)[:value]
      rescue
        nil
      end
    end

    def calls_received_unspecified
      begin
        element.find('li[data-metric-item-identifier="calls-received-unspecified"] .metric-value-count data')[:value]
      rescue
        nil
      end
    end
  end
end
