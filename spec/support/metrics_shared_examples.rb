RSpec.shared_examples_for 'uses the correct child entites, depending on the group by setting' do
  let(:time_period) { instance_double(TimePeriod, start_month: double, end_month: double, months: [start_month, end_month]) }
  subject { described_class.new(root, group_by: group_by, time_period: time_period) }

  let(:start_month) { instance_double(YearMonth) }
  let(:end_month) { instance_double(YearMonth) }
  let(:service) { instance_double(Service) }
  let(:monthly_service_metrics1) { instance_double(MonthlyServiceMetrics, month: start_month, service: service) }
  let(:child_monthly_service_metrics) { {} }

  before do
    root_monthly_service_metrics = []
    children.each do |child|
      service = instance_double(Service)
      monthly_service_metrics = instance_double(MonthlyServiceMetrics, month: start_month, service: service)
      allow(child).to receive_message_chain(:metrics, :joins, :between, :published) { [monthly_service_metrics] }

      root_monthly_service_metrics << monthly_service_metrics
      child_monthly_service_metrics[child] = monthly_service_metrics
    end

    allow(root).to receive_message_chain(:metrics, :joins, :between, :published) { root_monthly_service_metrics }

    obj = double(applicable?: true)
    allow(obj).to receive(:+) { obj }

    allow(CallsReceivedMetric).to receive(:from_metrics) { obj }
    allow(TransactionsReceivedMetric).to receive(:from_metrics) { obj }
    allow(TransactionsWithOutcomeMetric).to receive(:from_metrics) { obj }
  end

  it 'returns a metric group for each child entity' do
    entities = subject.metric_groups.map(&:entity)
    expect(entities).to match_array(children)
  end

  it 'includes calls received metric, for each child entry' do
    metric_doubles = children.each.with_object([]) do |child, memo|
      aggregate = instance_double(CallsReceivedMetric)
      allow(aggregate).to receive(:applicable?) { true }

      double = instance_double(CallsReceivedMetric, :+ => aggregate)
      allow(CallsReceivedMetric).to receive(:from_metrics).with(child_monthly_service_metrics[child]) { double }

      memo << aggregate
    end

    metrics = subject.metric_groups.flat_map(&:metrics)
    expect(metrics).to include(*metric_doubles)
  end

  it 'does not include calls received metric, for each child entry where not applicable' do
    metric_doubles = children.each.with_object([]) do |child, memo|
      aggregate = instance_double(CallsReceivedMetric)
      allow(aggregate).to receive(:applicable?) { false }

      double = instance_double(CallsReceivedMetric, :+ => aggregate)
      allow(CallsReceivedMetric).to receive(:from_metrics).with(child_monthly_service_metrics[child]) { double }

      memo << aggregate
    end

    metrics = subject.metric_groups.flat_map(&:metrics)
    expect(metrics).not_to include(*metric_doubles)
  end

  it 'includes transactions received metric, for each child entity' do
    metric_doubles = children.each.with_object([]) do |child, memo|
      aggregate = instance_double(TransactionsReceivedMetric)
      allow(aggregate).to receive(:applicable?) { true }

      double = instance_double(TransactionsReceivedMetric, :+ => aggregate)
      allow(TransactionsReceivedMetric).to receive(:from_metrics).with(child_monthly_service_metrics[child]) { double }

      memo << aggregate
    end

    metrics = subject.metric_groups.flat_map(&:metrics)
    expect(metrics).to include(*metric_doubles)
  end

  it 'does not include transactions received metric, for each child entity when not applicable' do
    metric_doubles = children.each.with_object([]) do |child, memo|
      aggregate = instance_double(TransactionsReceivedMetric)
      allow(aggregate).to receive(:applicable?) { false }

      double = instance_double(TransactionsReceivedMetric, :+ => aggregate)
      allow(TransactionsReceivedMetric).to receive(:from_metrics).with(child_monthly_service_metrics[child]) { double }

      memo << aggregate
    end

    metrics = subject.metric_groups.flat_map(&:metrics)
    expect(metrics).not_to include(*metric_doubles)
  end

  it 'includes transactions with outcome metric, for each child entity' do
    metric_doubles = children.each.with_object([]) do |child, memo|
      aggregate = instance_double(TransactionsWithOutcomeMetric)
      allow(aggregate).to receive(:applicable?) { true }

      double = instance_double(TransactionsWithOutcomeMetric, :+ => aggregate)
      allow(TransactionsWithOutcomeMetric).to receive(:from_metrics).with(child_monthly_service_metrics[child]) { double }

      memo << aggregate
    end

    metrics = subject.metric_groups.flat_map(&:metrics)
    expect(metrics).to include(*metric_doubles)
  end

  it 'does not include transactions received metric, for each child entity when not applicable' do
    metric_doubles = children.each.with_object([]) do |child, memo|
      aggregate = instance_double(TransactionsWithOutcomeMetric)
      allow(aggregate).to receive(:applicable?) { false }

      double = instance_double(TransactionsWithOutcomeMetric, :+ => aggregate)
      allow(TransactionsWithOutcomeMetric).to receive(:from_metrics).with(child_monthly_service_metrics[child]) { double }

      memo << aggregate
    end

    metrics = subject.metric_groups.flat_map(&:metrics)
    expect(metrics).not_to include(*metric_doubles)
  end
end
