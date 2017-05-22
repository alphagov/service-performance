CrossGovernmentServiceDataAPI::Service = Struct.new(:key, :name) do
  def self.build(response)
    new(response['natural_key'], response['name'])
  end
end
