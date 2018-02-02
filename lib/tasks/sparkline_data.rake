require 'csv'
namespace :sparkline_data do
  desc "Get spark line data"
  task services: :environment do
    h = {}
    output = Service.all.map do |service|
      metrics = MetricsPresenter.new(service, group_by: Metrics::GroupBy::Service, time_period: TimePeriod.default)
      trxn = metrics.metric_groups[0]
      h.merge!("#{service.name} - Total Transactions" => trxn.sorted_metrics_by_month[:total_transactions])
      h.merge!("#{service.name} - Online Transactions" => trxn.sorted_metrics_by_month[:online_transactions])
      h.merge!("#{service.name} - Phone Transactions" => trxn.sorted_metrics_by_month[:phone_transactions])
      h.merge!("#{service.name} - Paper Transactions" => trxn.sorted_metrics_by_month[:paper_transactions])
      h.merge!("#{service.name} - Face to Face Transactions" => trxn.sorted_metrics_by_month[:face_to_face_transactions])
      h.merge!("#{service.name} - Other Transactions" => trxn.sorted_metrics_by_month[:other_transactions])
    end
    CSV.open("service-data.csv", "w") {|csv| h.to_a.each {|elem| csv << elem } }
  end

  task departments: :environment do
    h = {}
    output = Department.all.map do |department|
      metrics = MetricsPresenter.new(department, group_by: Metrics::GroupBy::DeliveryOrganisation, time_period: TimePeriod.default)
      trxn = metrics.metric_groups[0]
      h.merge!("#{department.name} - Total Transactions" => trxn.sorted_metrics_by_month[:total_transactions])
      h.merge!("#{department.name} - Online Transactions" => trxn.sorted_metrics_by_month[:online_transactions])
      h.merge!("#{department.name} - Phone Transactions" => trxn.sorted_metrics_by_month[:phone_transactions])
      h.merge!("#{department.name} - Paper Transactions" => trxn.sorted_metrics_by_month[:paper_transactions])
      h.merge!("#{department.name} - Face to Face Transactions" => trxn.sorted_metrics_by_month[:face_to_face_transactions])
      h.merge!("#{department.name} - Other Transactions" => trxn.sorted_metrics_by_month[:other_transactions])
    end
    CSV.open("department-data.csv", "w") {|csv| h.to_a.each {|elem| csv << elem } }
  end
end
