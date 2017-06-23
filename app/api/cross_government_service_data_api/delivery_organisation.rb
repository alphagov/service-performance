CrossGovernmentServiceDataAPI::DeliveryOrganisation = Struct.new(:key, :name, :services_count) do
  def self.build(response)
    new(
      response['natural_key'],
      response['name'],
      response['services_count'],
    )
  end
end
