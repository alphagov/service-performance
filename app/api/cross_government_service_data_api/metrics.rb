class CrossGovernmentServiceDataAPI::Metrics

  def self.build(response)
    if response['department']
      department = CrossGovernmentServiceDataAPI::Department.build(response['department'])
    end

    if response['service']
      service = CrossGovernmentServiceDataAPI::Service.build(response['service'], department: department)
    end

    metrics = response['metrics'].index_by {|metric| metric['type'] }
    new(metrics, department: department, service: service)
  end

  def initialize(metrics, department: nil, service: nil)
    @department = department
    @service = service
    @metrics = metrics
  end

  attr_reader :department, :service

  def metrics
    [transactions_received, transactions_with_outcome, calls_received]
  end

  private

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
