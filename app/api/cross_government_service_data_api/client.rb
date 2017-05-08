class CrossGovernmentServiceDataAPI::Client

  def metrics_by_department
    response = connection.get '/v1/data/departments'
    data = response.body
    data.map do |response|
      CrossGovernmentServiceDataAPI::Metrics.build(response)
    end
  end

  private
  def connection
    @connection ||= Faraday.new 'http://localhost:3001' do |connection|
      connection.use :instrumentation

      connection.response :json
      connection.adapter Faraday.default_adapter
    end
  end
end
