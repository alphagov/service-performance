class ServiceOutcomeSummary < OutcomeSummary
  attr_reader :service

  def initialize(args)
    @service = args[:service]
    super(args)
  end

  private
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
end
