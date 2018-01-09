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

    TransactionsReceived = MetricSortAttribute.new('transactions-received', name: 'transactions received', keypath: %i[transactions_received_metric total], index: 1)
    TransactionsReceivedOnline = MetricSortAttribute.new('transactions-received-online', name: 'transactions received (online)', keypath: %i[transactions_received_metric online], index: 2)
    TransactionsReceivedPhone = MetricSortAttribute.new('transactions-received-phone', name: 'transactions received (phone)', keypath: %i[transactions_received_metric phone], index: 3)
    TransactionsReceivedPaper = MetricSortAttribute.new('transactions-received-paper', name: 'transactions received (paper)', keypath: %i[transactions_received_metric paper], index: 4)
    TransactionsReceivedFaceToFace = MetricSortAttribute.new('transactions-received-face-to-face', name: 'transactions received (face to face)', keypath: %i[transactions_received_metric face_to_face], index: 5)
    TransactionsReceivedOther = MetricSortAttribute.new('transactions-received-other', name: 'transactions received (other)', keypath: %i[transactions_received_metric other], index: 6)

    TransactionsEndingInOutcome = MetricSortAttribute.new('transactions-ending-in-outcome', name: 'transactions processed', keypath: %i[transactions_processed_metric total], index: 7)
    TransactionsEndingInOutcomeWithIntendedOutcome = MetricSortAttribute.new('transactions-ending-in-outcome-with-intended-outcome',
      name: "transactions ending in the user's intended outcome",
      keypath: %i[transactions_processed_metric with_intended_outcome],
      index: 8)

    CallsReceived = MetricSortAttribute.new('calls-received', name: 'calls received', keypath: %i[calls_received_metric total], index: 9)
    CallsReceivedPerformTransaction = MetricSortAttribute.new('calls-received-perform-transaction', name: 'calls received (perform transaction)', keypath: %i[calls_received_metric perform_transaction], index: 10)
    CallsReceivedGetInformation = MetricSortAttribute.new('calls-received-get-information', name: 'calls received (get information)', keypath: %i[calls_received_metric get_information], index: 11)
    CallsReceivedChaseProgress = MetricSortAttribute.new('calls-received-chase-progress', name: 'calls received (chase progress)', keypath: %i[calls_received_metric chase_progress], index: 12)
    CallsReceivedChallengeADecision = MetricSortAttribute.new('calls-received-challenge-a-decision', name: 'calls received (challenge a decision)', keypath: %i[calls_received_metric challenge_a_decision], index: 13)
    CallsReceivedOther = MetricSortAttribute.new('calls-received-other', name: 'calls received (other)', keypath: %i[calls_received_metric other], index: 14)
    CallsReceivedUnspecified = MetricSortAttribute.new('calls-received-unspecified', name: 'calls received (unspecified)', keypath: %i[calls_received_metric unspecified], index: 15)

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
    def initialize(entity, metrics_by_month)
      @entity = entity
      @metrics_by_month = metrics_by_month
      @service = nil
      if entity.class == Service
        @service = entity
      end
    end

    attr_reader :entity, :metrics_by_month, :service

    def transactions_received_metric
      metrics.map(&:transactions_received_metric).reduce(:+)
    end

    def transactions_processed_metric
      metrics.map(&:transactions_processed_metric).reduce(:+)
    end

    def calls_received_metric
      metrics.map(&:calls_received_metric).reduce(:+)
    end

  private

    def metrics
      metrics_by_month.values.flatten
    end
  end

  def initialize(root, group_by: nil, time_period: nil, search_term: nil)
    @root = root
    @group_by = group_by || GroupBy::Service
    @time_period = time_period
    @search_term = search_term
  end

  attr_reader :group_by, :root, :time_period

  def totals_metric_group
    totalled_metrics_by_month = metric_groups.each.with_object({}) do |metric_group, memo|
      metric_group.metrics_by_month.each do |month, metric|
        memo[month] ||= []
        memo[month] << metric
      end
    end

    MetricGroup.new(root, totalled_metrics_by_month)
  end

  def metric_groups
    metrics_by_selected_grouping.map do |(entity, metrics_by_month)|
      MetricGroup.new(entity, metrics_by_month)
    end
  end

  def published_monthly_service_metrics
    @published_monthly_service_metrics = root.metrics.preload(:service).between(time_period.start_month, time_period.end_month).published
  end

  def metrics_by_selected_grouping
    # populate metrics for services, in month's where they don't have published metrics, with null MonthlyServiceMetrics.
    metrics_by_service = published_monthly_service_metrics.group_by(&:service).each.with_object({}) do |(service, metrics), memo|
      memo[service] = time_period.months.each.with_object(metrics.index_by(&:month)) do |month, metrics_by_month|
        metrics_by_month[month] ||= MonthlyServiceMetrics::Null.new(service, month)
      end
    end

    # define a proc, which we can use to determine which group a given service's metrics should be in
    grouper = case group_by
              when GroupBy::Department
                ->(service) { service.department }
              when GroupBy::DeliveryOrganisation
                ->(service) { service.delivery_organisation }
              when GroupBy::Service
                ->(service) { service }
              else
                raise RuntimeError
              end

    # group the service metrics by the selected grouping
    metrics_by_service.each.with_object({}) do |(service, metrics_by_month), memo|
      key = grouper.(service)
      memo[key] ||= {}

      metrics_by_month.each do |month, metric|
        memo[key][month] ||= []
        memo[key][month] << metric
      end
    end
  end

private

  def entities
    raise NotImplementedError, "must be implemented by sub-classes"
  end
end
