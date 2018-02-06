require 'rails_helper'

RSpec.feature 'viewing metrics', type: :feature do
  before do
    department1 = FactoryGirl.create(:department, name: "Department for Business, Energy & Industrial Strategy")
    department2 = FactoryGirl.create(:department, name: "Department for Communities and Local Government")
    department3 = FactoryGirl.create(:department, name: "Department for Education")
    department4 = FactoryGirl.create(:department, name: "Department for Environment, Food & Rural Affairs")
    department5 = FactoryGirl.create(:department, name: "Department for Transport")
    department6 = FactoryGirl.create(:department, name: "Department for Work and Pensions")
    department7 = FactoryGirl.create(:department, name: "Ministry of Justice")

    delivery_organisation1 = FactoryGirl.create(:delivery_organisation, department: department1, name: "Department for Business, Energy & Industrial Strategy")
    delivery_organisation2 = FactoryGirl.create(:delivery_organisation, department: department2, name: "Department for Communities and Local Government")
    delivery_organisation3 = FactoryGirl.create(:delivery_organisation, department: department3, name: "Department for Education")
    delivery_organisation4 = FactoryGirl.create(:delivery_organisation, department: department4, name: "Department for Environment, Food & Rural Affairs")
    delivery_organisation5 = FactoryGirl.create(:delivery_organisation, department: department5, name: "Department for Transport")
    delivery_organisation6 = FactoryGirl.create(:delivery_organisation, department: department6, name: "Department for Work and Pensions")
    delivery_organisation7 = FactoryGirl.create(:delivery_organisation, department: department7, name: "Ministry of Justice")

    service1 = FactoryGirl.create(:service, delivery_organisation: delivery_organisation1, name: "File your Accounts")
    service2 = FactoryGirl.create(:service, delivery_organisation: delivery_organisation2, name: "Planning application appeals")
    service3 = FactoryGirl.create(:service, delivery_organisation: delivery_organisation3, name: "Get Into Teaching")
    service4 = FactoryGirl.create(:service, delivery_organisation: delivery_organisation4, name: "Get a wildlife licence")
    service5 = FactoryGirl.create(:service, delivery_organisation: delivery_organisation5, name: "Pay the Dartford Crossing charge (Dartcharge)")
    service6 = FactoryGirl.create(:service, delivery_organisation: delivery_organisation6, name: "Check your State Pension")
    service7 = FactoryGirl.create(:service, delivery_organisation: delivery_organisation7, name: "Appeal to the tax tribunal")

    time_period = TimePeriod.default
    FactoryGirl.create(:monthly_service_metrics, :published, service: service1, month: time_period.start_month, online_transactions: 4436000, calls_received: 171)
    FactoryGirl.create(:monthly_service_metrics, :published, service: service1, month: time_period.end_month, online_transactions: 917)
    FactoryGirl.create(:monthly_service_metrics, :published, service: service2, month: time_period.start_month, online_transactions: 11000)
    FactoryGirl.create(:monthly_service_metrics, :published, service: service2, month: time_period.end_month, online_transactions: 560)
    FactoryGirl.create(:monthly_service_metrics, :published, service: service3, month: time_period.start_month, online_transactions: 91000)
    FactoryGirl.create(:monthly_service_metrics, :published, service: service3, month: time_period.end_month, online_transactions: 223)
    FactoryGirl.create(:monthly_service_metrics, :published, service: service4, month: time_period.start_month, online_transactions: 12537000, calls_received: 213775)
    FactoryGirl.create(:monthly_service_metrics, :published, service: service4, month: time_period.end_month, online_transactions: 482)
    FactoryGirl.create(:monthly_service_metrics, :published, service: service5, month: time_period.start_month, online_transactions: 5747000, calls_received: 313749)
    FactoryGirl.create(:monthly_service_metrics, :published, service: service5, month: time_period.end_month, online_transactions: 785)
    FactoryGirl.create(:monthly_service_metrics, :published, service: service6, month: time_period.start_month, online_transactions: 3709000, calls_received: 467495)
    FactoryGirl.create(:monthly_service_metrics, :published, service: service6, month: time_period.end_month, online_transactions: 191)
    FactoryGirl.create(:monthly_service_metrics, :published, service: service7, month: time_period.start_month, online_transactions: 58000)
    FactoryGirl.create(:monthly_service_metrics, :published, service: service7, month: time_period.end_month, online_transactions: 140)
  end

  context 'sorting metrics' do
    with_conditional_javascript do
      it 'allows sorting of metric groups' do
        visit view_data_government_metrics_path(group_by: Metrics::GroupBy::Department)

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

    it 'collapses metric groups, when sorting by attributes (other than name)', js: true do
      visit view_data_government_metrics_path(group_by: Metrics::GroupBy::Department, order_by: "name")

      expect(page).to have_selector('.m-metric-group', count: 8)
      expect(page).to have_selector('.m-metric-group[data-behaviour~="m-metric-group__collapsible"]', count: 0)
      expect(page).to have_selector('.completeness', count: 8)

      select 'transactions received', from: 'Sort by'

      expect(page).to have_selector('.m-metric-group[data-behaviour~="m-metric-group__collapsible"]', count: 8)
    end

    it 'correctly shows transactions with outcome', js: true do
      visit view_data_government_metrics_path(group_by: Metrics::GroupBy::Department, order_by: "transactions_with_outcome")

      expect(page).to have_selector('.m-metric-group', count: 8)
      expect(page).to have_selector('.m-metric-group[data-behaviour~="m-metric-group__collapsible"]', count: 0)
      expect(page).to have_selector('.completeness', count: 8)
    end

    it 'gov totals show how many services' do
      visit view_data_government_metrics_path(group_by: Metrics::GroupBy::Department, order_by: "name")
      expect(page).to have_content('based on 7 services', count: 1)
    end

    it 'collapsed totals show how many services' do
      visit view_data_government_metrics_path(group_by: Metrics::GroupBy::Department, order_by: "transactions-received")
      expect(page).to have_content('based on 7 services', count: 1)
    end
  end

  context 'sometimes we have unspecified calls received' do
    it 'sometimes has unspecified values, sometimes not' do
      visit view_data_government_metrics_path(group_by: Metrics::GroupBy::Department)

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
        element.find('li[data-metric-item-identifier="calls-received"] .metric-value data')[:value]
      rescue
        nil
      end
    end
  end
end
