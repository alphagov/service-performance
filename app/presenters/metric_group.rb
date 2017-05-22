class MetricGroup < Struct.new(:name, :url, :metrics)
  module ToPartialPath
    def to_partial_path
      'metrics/' + self.class.name.demodulize.underscore
    end
  end

  def metrics
    @metrics ||= super.each {|metric| metric.extend(ToPartialPath) }
  end

  def transactions_received
    metrics.detect {|metric| metric.is_a?(CrossGovernmentServiceDataAPI::TransactionsReceivedMetric) }
  end

  def transactions_with_outcome
    metrics.detect {|metric| metric.is_a?(CrossGovernmentServiceDataAPI::TransactionsWithOutcomeMetric) }
  end
end
