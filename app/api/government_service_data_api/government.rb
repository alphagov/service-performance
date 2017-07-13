GovernmentServiceDataAPI::Government = Struct.new(:departments_count, :delivery_organisations_count, :services_count) do
  def self.build(response)
    new(
      response['departments_count'],
      response['delivery_organisations_count'],
      response['services_count'],
    )
  end
end
