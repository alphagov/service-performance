namespace :publish do
  desc "Publish all monthly metrics older than the start of the current month"
  task all: :environment do
    before = Date.today.beginning_of_month

    metrics = MonthlyServiceMetrics.where("month < ? and published=false", [before])
    metrics.each do |metric|
      Publisher.publish(metric)
    end
  end
end
