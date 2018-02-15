require 'csv'
namespace :sparkline_data do
  desc "Get spark line data"
  task services: :environment do
    h = {}
    Service.all.map do |service|
      metrics = MetricsPresenter.new(service, group_by: Metrics::GroupBy::Service, time_period: TimePeriod.default)
      trxn = metrics.metric_groups[0]
      h["#{service.name} - Total Transactions"] = trxn.sorted_metrics_by_month[:total_transactions]
      h["#{service.name} - Online Transactions"] = trxn.sorted_metrics_by_month[:online_transactions]
      h["#{service.name} - Phone Transactions"] = trxn.sorted_metrics_by_month[:phone_transactions]
      h["#{service.name} - Paper Transactions"] = trxn.sorted_metrics_by_month[:paper_transactions]
      h["#{service.name} - Face to Face Transactions"] = trxn.sorted_metrics_by_month[:face_to_face_transactions]
      h.merge!("#{service.name} - Other Transactions" => trxn.sorted_metrics_by_month[:other_transactions])
    end
    CSV.open("service-data.csv", "w") { |csv| h.to_a.each { |elem| csv << elem } }
  end
end

namespace :sparkline_data do
  task departments: :environment do
    h = {}
    Department.all.map do |department|
      metrics = MetricsPresenter.new(department, group_by: Metrics::GroupBy::DeliveryOrganisation, time_period: TimePeriod.default)
      trxn = metrics.metric_groups[0]
      h["#{department.name} - Total Transactions"] = trxn.sorted_metrics_by_month[:total_transactions]
      h["#{department.name} - Online Transactions"] = trxn.sorted_metrics_by_month[:online_transactions]
      h["#{department.name} - Phone Transactions"] = trxn.sorted_metrics_by_month[:phone_transactions]
      h["#{department.name} - Paper Transactions"] = trxn.sorted_metrics_by_month[:paper_transactions]
      h["#{department.name} - Face to Face Transactions"] = trxn.sorted_metrics_by_month[:face_to_face_transactions]
      h.merge!("#{department.name} - Other Transactions" => trxn.sorted_metrics_by_month[:other_transactions])
    end
    CSV.open("department-data.csv", "w") { |csv| h.to_a.each { |elem| csv << elem } }
  end
end
