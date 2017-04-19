class ServiceChannelSummary
  attr_reader :service,
              :time_period,
              :transactions_received_online,
              :transactions_received_phone,
              :transactions_received_paper,
              :transactions_received_face_to_face,
              :transactions_received_other

  alias :read_attribute_for_serialization :send

  def initialize(args)
    @service      = args[:service]
    @time_period  = args[:time_period]
    result_set    = sum_transactions_received
    set_data(result_set)
  end

  private
    attr_writer :transactions_received_online,
                :transactions_received_phone,
                :transactions_received_paper,
                :transactions_received_face_to_face,
                :transactions_received_other

    def sum_transactions_received
      sql = %(
        SELECT SUM(quantity)
        FROM transactions_received
        WHERE service_natural_key = '#{service.natural_key}'
        AND   time >= '#{time_period.period_begin}'
        AND   time <  '#{time_period.period_end}'
        GROUP BY channel
      )
      InfluxDB::Rails.client.query(sql)
    end

    def set_data(result_set)
      result_set.each do |member|
        tag_value = member['tags']['channel']
        tag_value.gsub!(/-/, '_')
        total_quantity = member['values'][0]['sum']
        send("transactions_received_#{tag_value}=", total_quantity)
      end
    end
end
