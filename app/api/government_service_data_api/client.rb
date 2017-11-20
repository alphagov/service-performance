class GovernmentServiceDataAPI::Client
  def government
    response = connection.get "/v1/data/government"
    GovernmentServiceDataAPI::Government.build(response.body)
  end

  def department(id)
    id = URI.escape(id)
    response = connection.get "/v1/data/departments/#{id}"

    GovernmentServiceDataAPI::Department.build(response.body)
  end

  def delivery_organisation(id)
    id = URI.escape(id)
    response = connection.get "/v1/data/delivery_organisations/#{id}"

    GovernmentServiceDataAPI::DeliveryOrganisation.build(response.body)
  end

  def service(id)
    id = URI.escape(id)
    response = connection.get "/v1/data/services/#{id}"

    department = GovernmentServiceDataAPI::Department.build(response.body['department'])
    delivery_organisation = GovernmentServiceDataAPI::DeliveryOrganisation.build(response.body['delivery_organisation'])

    GovernmentServiceDataAPI::Service.build(response.body, department: department, delivery_organisation: delivery_organisation)
  end

  def metrics(entity, group_by:)
    case entity
    when GovernmentServiceDataAPI::Government
      path = "/v1/data/government/metrics"
    when GovernmentServiceDataAPI::Department
      path = "/v1/data/departments/#{entity.key}/metrics"
    when GovernmentServiceDataAPI::DeliveryOrganisation
      path = "/v1/data/delivery_organisations/#{entity.key}/metrics"
    when GovernmentServiceDataAPI::Service
      path = "/v1/data/services/#{entity.key}/metrics"
    end

    response = connection.get(path, group_by: group_by)
    GovernmentServiceDataAPI::Metrics.build(response.body, entity: entity)
  end

private

  def connection
    @connection ||= Faraday.new(ENV.fetch('API_URL')) do |connection|
      connection.basic_auth ENV.fetch('API_USERNAME'), ENV.fetch('API_PASSWORD')

      connection.response :json
      connection.response :raise_error

      connection.use :instrumentation
      connection.use GovernmentServiceDataAPI::Logger

      connection.adapter Faraday.default_adapter
    end
  end
end
