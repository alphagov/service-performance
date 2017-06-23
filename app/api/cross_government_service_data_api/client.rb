class CrossGovernmentServiceDataAPI::Client
  def government
    response = connection.get "/v1/data/government"
    CrossGovernmentServiceDataAPI::Government.build(response.body)
  end

  def department(id)
    id = URI.escape(id)
    response = connection.get "/v1/data/departments/#{id}"

    CrossGovernmentServiceDataAPI::Department.build(response.body)
  end

  def delivery_organisation(id)
    id = URI.escape(id)
    response = connection.get "/v1/data/delivery_organisations/#{id}"

    CrossGovernmentServiceDataAPI::DeliveryOrganisation.build(response.body)
  end

  def service(id)
    id = URI.escape(id)
    response = connection.get "/v1/data/services/#{id}"

    department = CrossGovernmentServiceDataAPI::Department.build(response.body['department'])

    service = CrossGovernmentServiceDataAPI::Service.build(response.body, department: department)
  end

  def metric_groups(entity, group_by:)
    case entity
    when CrossGovernmentServiceDataAPI::Government
      path = "/v1/data/government/metrics"
    when CrossGovernmentServiceDataAPI::Department
      path = "/v1/data/departments/#{entity.key}/metrics"
    when CrossGovernmentServiceDataAPI::DeliveryOrganisation
      path = "/v1/data/delivery_organisations/#{entity.key}/metrics"
    when CrossGovernmentServiceDataAPI::Service
      path = "/v1/data/services/#{entity.key}/metrics"
    end

    response = connection.get(path, group_by: group_by)
    response.body['metric_groups'].map do |metric_group|
      CrossGovernmentServiceDataAPI::MetricGroup.build(metric_group)
    end
  end

  private
  def connection
    @connection ||= Faraday.new(ENV.fetch('API_URL')) do |connection|
      connection.basic_auth ENV.fetch('API_USERNAME'), ENV.fetch('API_PASSWORD')

      connection.response :json
      connection.response :raise_error

      connection.use :instrumentation
      connection.use CrossGovernmentServiceDataAPI::Logger

      connection.adapter Faraday.default_adapter
    end
  end
end
