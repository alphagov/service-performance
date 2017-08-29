class GovernmentServiceDataAPI::MetricGroup
  def self.build(response)
    entity_type = response['entity']['type']

    case entity_type
    when 'government'
      entity = GovernmentServiceDataAPI::Government.build(response['entity'])
    when 'department'
      entity = GovernmentServiceDataAPI::Department.build(response['entity'])
    when 'delivery-organisation'
      entity = GovernmentServiceDataAPI::DeliveryOrganisation.build(response['entity'])
    when 'service'
      entity = GovernmentServiceDataAPI::Service.build(response['entity'])
    end

    metrics = response['metrics'].index_by { |metric| metric['type'] }
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
    return GovernmentServiceDataAPI::TransactionsReceivedMetric.build(@metrics['transactions-received']) if @metrics.has_key? 'transactions-received'
    GovernmentServiceDataAPI::NonApplicableMetric.new("doesn't record transactions")
  end

  def transactions_with_outcome
    return GovernmentServiceDataAPI::TransactionsWithOutcomeMetric.build(@metrics['transactions-with-outcome']) if @metrics.has_key? 'transactions-with-outcome'
    GovernmentServiceDataAPI::NonApplicableMetric.new("doesn't measure outcomes")
  end

  def calls_received
    return GovernmentServiceDataAPI::CallsReceivedMetric.build(@metrics['calls-received']) if @metrics.has_key? 'calls-received'
    GovernmentServiceDataAPI::NonApplicableMetric.new("doesn't receive calls")
  end
end
