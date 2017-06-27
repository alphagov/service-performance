require 'rails_helper'

RSpec.feature 'viewing metrics', type: :feature do

  specify 'sorting metrics', cassette: 'viewing-metrics-sorting-metrics' do
    visit government_metrics_path(group_by: Metrics::Group::Department)

    expect(page).to have_text('Service data for UK government')

    select 'transactions received', from: 'Sort by'
    click_on 'Apply'

    output = metric_groups.map {|metric_group| [metric_group.name, metric_group.transactions_received_total] }.to_a
    expect(output).to eq([
      ["Ministry of Justice",                                   "593254687"],
      ["Department for Transport",                              "118679511"],
      ["Department of Health",                                   "18132669"],
      ["Department for Education",                               "13000475"],
      ["Department for Environment Food & Rural Affairs",         "3000039"],
      ["HM Revenue & Customs",                                          "0"],
      ["Department for Business, Energy & Industrial Strategy",         "0"],
    ])

    choose 'Low to High'
    click_on 'Apply'

    expect(output).to eq([
      ["Department for Business, Energy & Industrial Strategy",         "0"],
      ["HM Revenue & Customs",                                          "0"],
      ["Department for Environment Food & Rural Affairs",         "3000039"],
      ["Department for Education",                               "13000475"],
      ["Department of Health",                                   "18132669"],
      ["Department for Transport",                              "118679511"],
      ["Ministry of Justice",                                   "593254687"],
    ])
  end

  private

  def metric_groups
    page.all('.metric-group').map { |element| MetricGroup.new(element) }
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
      element.find('.m-metric__transactions-received .m-metric-headline data').value
    end
  end
end