class OutcomeSummary
  attr_reader :time_period,
              :transactions_ending_any_outcome,
              :transactions_ending_user_intended_outcome

  def initialize(args)
    @time_period  = args[:time_period]
    result_set    = sum_transactions_with_outcome
    set_attrs(result_set)
  end

  private
    attr_writer :transactions_ending_any_outcome,
                :transactions_ending_user_intended_outcome

    def sum_transactions_with_outcome
      # Implement in subclass
    end

    def set_attrs(result_set)
      result_set.each do |member|
        tag_value = member['tags']['outcome']
        tag_value.gsub!(/-/, '_')
        total_quantity = member['values'][0]['sum']
        send("transactions_ending_#{tag_value}_outcome=", total_quantity)
      end
    end
end