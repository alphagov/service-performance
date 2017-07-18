RSpec.shared_examples_for 'uses the correct child entites, depending on the group by setting' do
  subject(:government_metrics) { described_class.new(root, group_by: group_by, time_period: time_period) }

  before do
    allow(AggregatedCallsReceivedMetric).to receive(:new)
    allow(AggregatedTransactionsReceivedMetric).to receive(:new)
    allow(AggregatedTransactionsWithOutcomeMetric).to receive(:new)
  end

  it 'returns a metric group for each child entity' do
    entities = subject.metric_groups.map(&:entity)
    expect(entities).to match_array(children)
  end

  it 'includes aggregated calls received metric, for each child entry' do
    metric_doubles = children.each.with_object([]) do |child, memo|
      double = instance_double(AggregatedCallsReceivedMetric)
      allow(AggregatedCallsReceivedMetric).to receive(:new).with(child, time_period) { double }

      memo << double
    end

    metrics = government_metrics.metric_groups.flat_map(&:metrics)
    expect(metrics).to include(*metric_doubles)
  end

  it 'includes aggregated transactions received metric, for each child entity' do
    metric_doubles = children.each.with_object([]) do |child, memo|
      double = instance_double(AggregatedTransactionsReceivedMetric)
      allow(AggregatedTransactionsReceivedMetric).to receive(:new).with(child, time_period) { double }

      memo << double
    end

    metrics = government_metrics.metric_groups.flat_map(&:metrics)
    expect(metrics).to include(*metric_doubles)
  end

  it 'includes aggregated transactions received metric, for each child entity' do
    metric_doubles = children.each.with_object([]) do |child, memo|
      double = instance_double(AggregatedTransactionsWithOutcomeMetric)
      allow(AggregatedTransactionsWithOutcomeMetric).to receive(:new).with(child, time_period) { double }

      memo << double
    end

    metrics = government_metrics.metric_groups.flat_map(&:metrics)
    expect(metrics).to include(*metric_doubles)
  end
end
