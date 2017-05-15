class CrossGovernmentServiceDataAPI::Metrics

  def self.build(response)
    department = CrossGovernmentServiceDataAPI::Department.build(response['department'])
    metrics = response['metrics'].index_by {|metric| metric['type'] }
    new(department, metrics)
  end

  def initialize(department, metrics)
    @department = department
    @metrics = metrics
  end

  attr_reader :department

  def transactions_received
    CrossGovernmentServiceDataAPI::TransactionsReceivedMetric.build(metrics['transactions-received'])
  end

  def transactions_with_outcome
    CrossGovernmentServiceDataAPI::TransactionsWithOutcomeMetric.build(metrics['transactions-with-outcome'])
  end

  private

  attr_reader :metrics
end
