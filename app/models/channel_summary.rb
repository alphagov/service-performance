class ChannelSummary
  attr_reader :time_period,
              :transactions_received_online,
              :transactions_received_phone,
              :transactions_received_paper,
              :transactions_received_face_to_face,
              :transactions_received_other

  def initialize(args)
    @time_period  = args[:time_period]
    result_set    = sum_transactions_received
    set_attrs(result_set)
  end

  private
    attr_writer :transactions_received_online,
                :transactions_received_phone,
                :transactions_received_paper,
                :transactions_received_face_to_face,
                :transactions_received_other

    def sum_transactions_received
      # Implement in subclass
    end

    def set_attrs(result_set)
      result_set.each do |member|
        tag_value = member['tags']['channel']
        tag_value.gsub!(/-/, '_')
        total_quantity = member['values'][0]['sum']
        send("transactions_received_#{tag_value}=", total_quantity)
      end
    end
end
