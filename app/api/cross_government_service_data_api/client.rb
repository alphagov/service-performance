class CrossGovernmentServiceDataAPI::Client

  def metrics_by_department
    response = connection.get '/v1/data/departments'
    data = response.body
    data.map do |response|
      CrossGovernmentServiceDataAPI::Metrics.build(response)
    end
  end

  def services_metrics_by_department(department_id)
    department_id = URI.escape(department_id)
    response = connection.get "/v1/data/departments/#{department_id}/services"
    data = response.body
    data.map do |response|
      CrossGovernmentServiceDataAPI::Metrics.build(response)
    end
  end

  private
  def connection
    @connection ||= Faraday.new(ENV.fetch('API_URL')) do |connection|
      connection.use :instrumentation

      connection.basic_auth ENV.fetch('API_USERNAME'), ENV.fetch('API_PASSWORD')

      connection.response :logger, Rails.logger
      connection.response :json
      connection.response :raise_error
      connection.adapter Faraday.default_adapter
    end
  end
end
