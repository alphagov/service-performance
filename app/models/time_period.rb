class TimePeriod
  attr_reader :months_ago, :period_begin, :period_end

  def initialize(args={})
    @months_ago   = args.fetch(:months_ago, 2)
    @period_begin = args.fetch(:period_begin, default_period_begin)
    @period_end   = args.fetch(:period_end, default_period_end)
  end

  private
    def default_period_begin
      (DateTime.now - (months_ago + 11).months).beginning_of_month
    end

    def default_period_end
      (DateTime.now - (months_ago.months)).end_of_month
    end
end
