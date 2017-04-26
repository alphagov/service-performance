class DepartmentChannelSummary < ChannelSummary
  attr_reader :department

  def initialize(args)
    @department = args[:department]
    super(args)
  end

  private
    def sum_transactions_received
      sql = %(
        SELECT SUM(quantity)
        FROM transactions_received
        WHERE department_natural_key = '#{department.natural_key}'
        AND   time >= '#{time_period.period_begin}'
        AND   time <  '#{time_period.period_end}'
        GROUP BY channel
      )
      InfluxDB::Rails.client.query(sql)
    end
end
