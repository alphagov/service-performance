class Metrics
  module GroupBy
    Government = 'government'.freeze
    Department = 'department'.freeze
    DeliveryOrganisation = 'delivery_organisation'.freeze
    Service = 'service'.freeze
  end

  module Items
    class MetricSortAttribute
      @attributes = {}

      def self.add(identifier, obj)
        @attributes[identifier] = obj
      end

      def self.get(identifier)
        @attributes.fetch(identifier, nil)
      end

      def self.all
        @attributes.values.sort_by(&:index)
      end

      def initialize(identifier, name:, keypath:, index:)
        @identifier = identifier
        @name = name
        @keypath = keypath
        @index = index

        self.class.add(identifier, self)
      end

      attr_reader :identifier, :name, :index

      def value(metric_group)
        @keypath.reduce(metric_group, :send)
      end

      def ==(other)
        self.identifier == other.identifier
      end
    end

    Name = MetricSortAttribute.new('name', name: 'name', keypath: %i[entity name], index: 0)

    TransactionsReceived = MetricSortAttribute.new('transactions-received', name: 'transactions received', keypath: %i[transactions_received total], index: 1)
    TransactionsReceivedOnline = MetricSortAttribute.new('transactions-received-online', name: 'transactions received (online)', keypath: %i[transactions_received online], index: 2)
    TransactionsReceivedPhone = MetricSortAttribute.new('transactions-received-phone', name: 'transactions received (phone)', keypath: %i[transactions_received phone], index: 3)
    TransactionsReceivedPaper = MetricSortAttribute.new('transactions-received-paper', name: 'transactions received (paper)', keypath: %i[transactions_received paper], index: 4)
    TransactionsReceivedFaceToFace = MetricSortAttribute.new('transactions-received-face-to-face', name: 'transactions received (face to face)', keypath: %i[transactions_received face_to_face], index: 5)
    TransactionsReceivedOther = MetricSortAttribute.new('transactions-received-other', name: 'transactions received (other)', keypath: %i[transactions_received other], index: 6)

    TransactionsEndingInOutcome = MetricSortAttribute.new('transactions-ending-in-outcome', name: 'transactions processed', keypath: %i[transactions_with_outcome count], index: 7)
    TransactionsEndingInOutcomeWithIntendedOutcome = MetricSortAttribute.new('transactions-ending-in-outcome-with-intended-outcome',
      name: "transactions ending in the user's intended outcome",
      keypath: %i[transactions_with_outcome count_with_intended_outcome],
      index: 8)

    CallsReceived = MetricSortAttribute.new('calls-received', name: 'calls received', keypath: %i[calls_received total], index: 9)
    CallsReceivedPerformTransaction = MetricSortAttribute.new('calls-received-perform-transaction', name: 'calls received (perform transaction)', keypath: %i[calls_received perform_transaction], index: 10)
    CallsReceivedGetInformation = MetricSortAttribute.new('calls-received-get-information', name: 'calls received (get information)', keypath: %i[calls_received get_information], index: 11)
    CallsReceivedChaseProgress = MetricSortAttribute.new('calls-received-chase-progress', name: 'calls received (chase progress)', keypath: %i[calls_received chase_progress], index: 12)
    CallsReceivedChallengeADecision = MetricSortAttribute.new('calls-received-challenge-a-decision', name: 'calls received (challenge a decision)', keypath: %i[calls_received challenge_a_decision], index: 13)
    CallsReceivedOther = MetricSortAttribute.new('calls-received-other', name: 'calls received (other)', keypath: %i[calls_received other], index: 14)
    CallsReceivedUnspecified = MetricSortAttribute.new('calls-received-unspecified', name: 'calls received (unspecified)', keypath: %i[calls_received unspecified], index: 15)

    def get_metric_sort_attribute(identifier)
      MetricSortAttribute.get(identifier) || Name
    end

    module_function :get_metric_sort_attribute
  end

  module Order
    Ascending = 'asc'.freeze
    Descending = 'desc'.freeze
  end

  class MetricGroup
    def initialize(entity, metrics)
      @entity = entity
      @metrics = metrics
    end

    attr_reader :entity, :metrics
  end

  def self.default_group_by
    self.valid_group_bys.first
  end

  def initialize(root, group_by: nil, time_period:)
    group_by ||= self.class.default_group_by
    raise ArgumentError, "unknown group_by: #{group_by.inspect}" unless self.class.valid_group_bys.include?(group_by)

    @root = root
    @group_by = group_by
    @time_period = time_period
  end

  attr_reader :group_by, :root, :time_period

  def metrics(entity: root)
    metrics = published_monthly_service_metrics(entity).each.with_object({}) do |metric, memo|
      memo[metric.service] ||= time_period.months.each.with_object({}) do |month, months|
        months[month] = MonthlyServiceMetrics::Null.new(metric.service, month)
      end
      memo[metric.service][metric.month] = metric
    end

    values = metrics.each.with_object([]) do |(_service, months), memo|
      months.each do |_month, metric|
        memo << metric
      end
    end

    [
      values.map(&TransactionsReceivedMetric).reduce(:+),
      values.map(&TransactionsWithOutcomeMetric).reduce(:+),
      values.map(&CallsReceivedMetric).reduce(:+),
    ]
  end

  def metric_groups
    entities.map { |entity|
      m = metrics(entity: entity)
      MetricGroup.new(entity, m)
    }
  end

  def published_monthly_service_metrics(entity = root)
    entity.metrics.joins(:service).between(time_period.start_month, time_period.end_month).published
  end

private

  def entities
    raise NotImplementedError, "must be implemented by sub-classes"
  end
end
