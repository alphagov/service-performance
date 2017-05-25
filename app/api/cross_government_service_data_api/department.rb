CrossGovernmentServiceDataAPI::Department = Struct.new(:key, :name, :website, :agencies_count, :services_count) do
  def self.build(response)
    new(
      response['natural_key'],
      response['name'],
      response['website'],
      response['agencies_count'],
      response['services_count']
    )
  end
end
