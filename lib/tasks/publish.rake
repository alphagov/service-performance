namespace :publish do
  desc "Publish all monthly metrics older than the start of the current month"
  task all: :environment do
    before = Date.today.beginning_of_month

    ActiveRecord::Base.transaction do
      MonthlyServiceMetrics.unpublished.where("month < ?", [before]).update_all(published: true)
    end
  end
end
