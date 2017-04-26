class DepartmentOutcomeSummary < OutcomeSummary
  attr_reader :department

  def initialize(args)
    @department = args[:department]
    super(args)
  end

  private
    def sum_transactions_with_outcome
      sql = %(
        SELECT SUM(quantity)
        FROM transactions_with_outcome
        WHERE department_natural_key = '#{department.natural_key}'
        AND   time >= '#{time_period.period_begin}'
        AND   time <  '#{time_period.period_end}'
        GROUP BY outcome
      )
      InfluxDB::Rails.client.query(sql)
    end
end
