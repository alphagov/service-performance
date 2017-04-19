class ServiceOutcomeSummary
  attr_reader :service,
              :time_period,
              :transactions_ending_any_outcome,
              :transactions_ending_user_intended_outcome

  def initialize(args)
    @service      = args[:service]
    @time_period  = args[:time_period]
    result_set    = sum_transactions_with_outcome
    set_data(result_set)
  end

  private
    attr_writer :transactions_ending_any_outcome,
                :transactions_ending_user_intended_outcome

    def sum_transactions_with_outcome
      sql = %(
        SELECT SUM(quantity)
        FROM transactions_with_outcome
        WHERE service_natural_key = '#{service.natural_key}'
        AND   time >= '#{time_period.period_begin}'
        AND   time <  '#{time_period.period_end}'
        GROUP BY outcome
      )
      InfluxDB::Rails.client.query(sql)
    end

    def set_data(result_set)
      result_set.each do |member|
        tag_value = member['tags']['outcome']
        tag_value.gsub!(/-/, '_')
        total_quantity = member['values'][0]['sum']
        send("transactions_ending_#{tag_value}_outcome=", total_quantity)
      end
    end
end
