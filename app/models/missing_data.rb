class MissingData
  def initialize(service_name, data_provided)
    @service_name = service_name
    @data_provided = data_provided
    @metrics = []
  end

  def add_metrics(name, provided_percentage, months_missing)
    @metrics << { name: name, percentage: provided_percentage, months_missing: months_missing }
  end

  attr_reader :service_name, :metrics, :data_provided
end
