GovernmentServiceDataAPI::DeliveryOrganisation = Struct.new(:key, :name, :services_count, :department) do
  def self.build(response)
    return nil if response.nil?

    department = GovernmentServiceDataAPI::Department.build(response['department'])

    new(
      response['natural_key'],
      response['name'],
      response['services_count'],
      department,
    )
  end
end
