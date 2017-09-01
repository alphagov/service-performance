RSpec.shared_examples_for 'uses the correct child entites, depending on the group by setting' do
  subject(:government_metrics) { described_class.new(root, group_by: group_by, time_period: time_period) }

  before do
    obj = double(applicable?: true)

    allow(AggregatedCallsReceivedMetric).to receive(:new) { obj }
    allow(AggregatedTransactionsReceivedMetric).to receive(:new) { obj }
    allow(AggregatedTransactionsWithOutcomeMetric).to receive(:new) { obj }
  end

  it 'returns a metric group for each child entity' do
    entities = subject.metric_groups.map(&:entity)
    expect(entities).to match_array(children)
  end

  it 'includes aggregated calls received metric, for each child entry' do
    metric_doubles = children.each.with_object([]) do |child, memo|
      double = instance_double(AggregatedCallsReceivedMetric)
      allow(AggregatedCallsReceivedMetric).to receive(:new).with(child, time_period) { double }
      allow(double).to receive(:applicable?) { true }

      memo << double
    end

    metrics = government_metrics.metric_groups.flat_map(&:metrics)
    expect(metrics).to include(*metric_doubles)
  end

  it 'does not include aggregated calls received metric, for each child entry where not applicable' do
    metric_doubles = children.each.with_object([]) do |child, memo|
      double = instance_double(AggregatedCallsReceivedMetric)
      allow(AggregatedCallsReceivedMetric).to receive(:new).with(child, time_period) { double }
      allow(double).to receive(:applicable?) { false }

      memo << double
    end

    metrics = government_metrics.metric_groups.flat_map(&:metrics)
    expect(metrics).not_to include(*metric_doubles)
  end

  it 'includes aggregated transactions received metric, for each child entity' do
    metric_doubles = children.each.with_object([]) do |child, memo|
      double = instance_double(AggregatedTransactionsReceivedMetric)
      allow(AggregatedTransactionsReceivedMetric).to receive(:new).with(child, time_period) { double }
      allow(double).to receive(:applicable?) { true }

      memo << double
    end

    metrics = government_metrics.metric_groups.flat_map(&:metrics)
    expect(metrics).to include(*metric_doubles)
  end

  it 'does not include aggregated transactions received metric, for each child entity when not applicable' do
    metric_doubles = children.each.with_object([]) do |child, memo|
      double = instance_double(AggregatedTransactionsReceivedMetric)
      allow(AggregatedTransactionsReceivedMetric).to receive(:new).with(child, time_period) { double }
      allow(double).to receive(:applicable?) { false }

      memo << double
    end

    metrics = government_metrics.metric_groups.flat_map(&:metrics)
    expect(metrics).not_to include(*metric_doubles)
  end

  it 'includes aggregated transactions received metric, for each child entity' do
    metric_doubles = children.each.with_object([]) do |child, memo|
      double = instance_double(AggregatedTransactionsWithOutcomeMetric)
      allow(AggregatedTransactionsWithOutcomeMetric).to receive(:new).with(child, time_period) { double }
      allow(double).to receive(:applicable?) { true }

      memo << double
    end

    metrics = government_metrics.metric_groups.flat_map(&:metrics)
    expect(metrics).to include(*metric_doubles)
  end

  it 'does not include aggregated transactions received metric, for each child entity when not applicable' do
    metric_doubles = children.each.with_object([]) do |child, memo|
      double = instance_double(AggregatedTransactionsWithOutcomeMetric)
      allow(AggregatedTransactionsWithOutcomeMetric).to receive(:new).with(child, time_period) { double }
      allow(double).to receive(:applicable?) { false }

      memo << double
    end

    metrics = government_metrics.metric_groups.flat_map(&:metrics)
    expect(metrics).not_to include(*metric_doubles)
  end
end
