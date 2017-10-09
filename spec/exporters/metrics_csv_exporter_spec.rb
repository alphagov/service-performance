require 'rails_helper'

RSpec.describe MetricsCSVExporter, type: :exporter do
  subject(:exporter) { MetricsCSVExporter.new(MonthlyServiceMetrics.all) }

  it 'exports the metrics, per month, per service' do
    service1 = FactoryGirl.create(:service, name: 'Apply for Passport')
    FactoryGirl.create(:monthly_service_metrics, service: service1, month: YearMonth.new(2017, 7), online_transactions: 10_000)
    FactoryGirl.create(:monthly_service_metrics, service: service1, month: YearMonth.new(2017, 8), online_transactions: 11_000)

    service2 = FactoryGirl.create(:service, name: 'Renew Passport')
    FactoryGirl.create(:monthly_service_metrics, service: service2, month: YearMonth.new(2017, 8), online_transactions: 12_000)

    fields = rows.map { |row| [row.service_name, row.month, row.online_transactions, row.phone_transactions] }
    expect(fields).to match_array([
      ['Apply for Passport', 'Jul 2017', '10000', 'N/P'],
      ['Apply for Passport', 'Aug 2017', '11000', 'N/P'],
      ['Renew Passport', 'Aug 2017', '12000', 'N/P'],
    ])
  end

  it "export 'N/A' when a metric item has been set as not applicable" do
    service1 = FactoryGirl.create(:service, name: 'Apply for Passport', online_transactions_applicable: false)
    FactoryGirl.create(:monthly_service_metrics, service: service1, month: YearMonth.new(2017, 7))

    fields = rows.map { |row| [row.service_name, row.online_transactions] }
    expect(fields).to match_array([
      ['Apply for Passport', 'N/A']
    ])
  end

  private

  def rows(rows = exporter.to_csv)
    CSV.parse(rows, headers: true).map { |row| Row.new(row) }
  end

  class Row
    def initialize(row)
      @row = row
    end

    def month
      @row[0]
    end

    def service_name
      @row[1]
    end

    def online_transactions
      @row[6]
    end

    def phone_transactions
      @row[7]
    end
  end
end
