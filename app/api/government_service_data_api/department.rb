GovernmentServiceDataAPI::Department = Struct.new(:key, :name, :website, :delivery_organisations_count, :services_count) do
  def self.build(response)
    new(
      response['natural_key'],
      response['name'],
      response['website'],
      response['delivery_organisations_count'],
      response['services_count']
    )
  end
end
