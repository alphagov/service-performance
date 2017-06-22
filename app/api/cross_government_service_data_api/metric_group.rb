class CrossGovernmentServiceDataAPI::MetricGroup
  def self.build(response)
    entity_type = response['entity']['type']

    case entity_type
    when 'government'
      entity = CrossGovernmentServiceDataAPI::Government.build(response['entity'])
    when 'department'
      entity = CrossGovernmentServiceDataAPI::Department.build(response['entity'])
    when 'delivery-organisation'
      entity = CrossGovernmentServiceDataAPI::DeliveryOrganisation.build(response['entity'])
    when 'service'
      entity = CrossGovernmentServiceDataAPI::Service.build(response['entity'])
    end

    metrics = response['metrics'].index_by {|metric| metric['type'] }
    new(entity, metrics)
  end

  def initialize(entity, metrics)
    @entity = entity
    @metrics = metrics
  end

  attr_reader :entity

  def metrics
    [transactions_received, transactions_with_outcome, calls_received]
  end

  def transactions_received
    CrossGovernmentServiceDataAPI::TransactionsReceivedMetric.build(@metrics['transactions-received'])
  end

  def transactions_with_outcome
    CrossGovernmentServiceDataAPI::TransactionsWithOutcomeMetric.build(@metrics['transactions-with-outcome'])
  end

  def calls_received
    CrossGovernmentServiceDataAPI::CallsReceivedMetric.new
  end
end
