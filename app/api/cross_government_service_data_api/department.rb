CrossGovernmentServiceDataAPI::Department = Struct.new(:key, :name, :website) do
  def self.build(response)
    new(response['natural_key'], response['natural_name'], response['website'])
  end
end
