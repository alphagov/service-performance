require 'rails_helper'

RSpec.feature 'viewing metrics', type: :feature do
  before do
    @department1 = FactoryBot.create(:department, name: "Department for Business, Energy & Industrial Strategy")
    @delivery_organisation1 = FactoryBot.create(:delivery_organisation, department: @department1, name: "Department for Business, Energy & Industrial Strategy")
    @service1 = FactoryBot.create(:service, delivery_organisation: @delivery_organisation1, name: "File your Accounts")

    time_period = TimePeriod.default
    FactoryBot.create(:monthly_service_metrics, :published, service: @service1, month: time_period.start_month, online_transactions: 4436000, calls_received: 171)
  end

  context 'grouped by department' do
    it 'links to government page' do
      visit view_data_government_metrics_path(group_by: Metrics::GroupBy::Department)

      expect(page).to have_text('Service data for UK government')

      within(:xpath, '/html/body/main/div/div/div[2]/ul/li[1]') do
        expect(page).to have_text('Total for UK government')
        click_on 'Transactions received'

        expect(page).to have_current_path("/performance-data/government")
      end
    end

    it 'links to department page' do
      visit view_data_government_metrics_path(group_by: Metrics::GroupBy::Department)

      expect(page).to have_text('Service data for UK government')

      within(:xpath, '/html/body/main/div/div/div[2]/ul/li[2]') do
        expect(page).to have_text('Department for Business, Energy & Industrial Strategy')
        click_on 'Transactions received'

        expect(page).to have_current_path("/performance-data/departments/#{@department1.natural_key}")
      end
    end
  end

  context 'grouped by delivery organisation' do
    it 'links to government page' do
      visit view_data_government_metrics_path(group_by: Metrics::GroupBy::DeliveryOrganisation)

      expect(page).to have_text('Service data for UK government')

      within(:xpath, '/html/body/main/div/div/div[2]/ul/li[1]') do
        expect(page).to have_text('Total for UK government')
        click_on 'Transactions received'

        expect(page).to have_current_path("/performance-data/government")
      end
    end

    it 'links to delivery organisation page' do
      visit view_data_government_metrics_path(group_by: Metrics::GroupBy::DeliveryOrganisation)

      expect(page).to have_text('Service data for UK government')

      within(:xpath, '/html/body/main/div/div/div[2]/ul/li[2]') do
        expect(page).to have_text('Department for Business, Energy & Industrial Strategy')
        click_on 'Transactions received'

        expect(page).to have_current_path("/performance-data/delivery_organisations/#{@delivery_organisation1.natural_key}")
      end
    end
  end

  context 'grouped by service' do
    it 'links to government page' do
      visit view_data_government_metrics_path(group_by: Metrics::GroupBy::Service)

      expect(page).to have_text('Service data for UK government')

      within(:xpath, '/html/body/main/div/div/div[2]/ul/li[1]') do
        expect(page).to have_text('Total for UK government')
        click_on 'Transactions received'

        expect(page).to have_current_path("/performance-data/government")
      end
    end

    it 'links to service page' do
      visit view_data_government_metrics_path(group_by: Metrics::GroupBy::Service)

      expect(page).to have_text('Service data for UK government')

      within(:xpath, '/html/body/main/div/div/div[2]/ul/li[2]') do
        expect(page).to have_text('File your Accounts')
        click_on 'Transactions received'

        expect(page).to have_current_path("/performance-data/services/#{@service1.natural_key}")
      end
    end
  end
end
