namespace :update do
  desc "Update rejected metrics for published metrics"
  task rejected: :environment do
    MonthlyServiceMetrics.where(published: true).each { |m|
      if !m.transactions_processed.blank? && !m.transactions_processed_accepted.blank?
        m.transactions_processed_rejected = m.transactions_processed - m.transactions_processed_accepted
        m.save
      end
    }
  end
end
