module Metrics
  module Group
    Government = 'government'.freeze
    Department = 'department'.freeze
    DeliveryOrganisation = 'delivery_organisation'.freeze
    Service = 'service'.freeze
  end

  module Items
    class MetricSortAttribute
      def initialize(identifier, name:, keypath:, index:)
        @identifier = identifier
        @name = name
        @keypath = keypath
        @index = index
      end

      attr_reader :identifier, :name, :index

      def value(metric_group)
        @keypath.reduce(metric_group, :send)
      end

      def ==(other)
        self.identifier == other.identifier
      end
    end

    Name = MetricSortAttribute.new('name', name: 'name', keypath: [:entity, :name], index: 0)

    TransactionsReceived = MetricSortAttribute.new('transactions-received', name: 'transactions received', keypath: [:transactions_received, :total], index: 1)
    TransactionsReceivedOnline = MetricSortAttribute.new('transactions-received-online', name: 'transactions received (online)', keypath: [:transactions_received, :online], index: 2)
    TransactionsReceivedPhone = MetricSortAttribute.new('transactions-received-phone', name: 'transactions received (phone)', keypath: [:transactions_received, :phone], index: 3)
    TransactionsReceivedPaper = MetricSortAttribute.new('transactions-received-paper', name: 'transactions received (paper)', keypath: [:transactions_received, :paper], index: 4)
    TransactionsReceivedFaceToFace = MetricSortAttribute.new('transactions-received-face-to-face', name: 'transactions received (face to face)', keypath: [:transactions_received, :face_to_face], index: 5)
    TransactionsReceivedOther = MetricSortAttribute.new('transactions-received-other', name: 'transactions received (other)', keypath: [:transactions_received, :other], index: 6)

    TransactionsEndingInOutcome = MetricSortAttribute.new('transactions-ending-in-outcome', name: 'transactions processed', keypath: [:transactions_with_outcome, :count], index: 7)
    TransactionsEndingInOutcomeWithIntendedOutcome = MetricSortAttribute.new('transactions-ending-in-outcome-with-intended-outcome',
      name: "transactions ending in the user's intended outcome",
      keypath: [:transactions_with_outcome, :count_with_intended_outcome],
      index: 8)

    CallsReceived = MetricSortAttribute.new('calls-received', name: 'calls received', keypath: [:calls_received, :total], index: 9)
    CallsReceivedPerformTransaction = MetricSortAttribute.new('calls-received-perform-transaction', name: 'calls received (perform transaction)', keypath: [:calls_received, :perform_transaction], index: 10)
    CallsReceivedGetInformation = MetricSortAttribute.new('calls-received-get-information', name: 'calls received (get information)', keypath: [:calls_received, :get_information], index: 11)
    CallsReceivedChaseProgress = MetricSortAttribute.new('calls-received-chase-progress', name: 'calls received (chase progress)', keypath: [:calls_received, :chase_progress], index: 12)
    CallsReceivedChallengeADecision = MetricSortAttribute.new('calls-received-challenge-a-decision', name: 'calls received (challenge a decision)', keypath: [:calls_received, :challenge_a_decision], index: 13)
    CallsReceivedOther = MetricSortAttribute.new('calls-received-other', name: 'calls received (other)', keypath: [:calls_received, :other], index: 14)

    def get_metric_sort_attribute(identifier)
      get_all_metric_sort_attributes.select { |obj| obj.identifier == identifier }.first || Name
    end

    def get_all_metric_sort_attributes
      ObjectSpace.each_object(MetricSortAttribute).sort_by(&:index)
    end


    module_function :get_metric_sort_attribute, :get_all_metric_sort_attributes
  end

  module Order
    Ascending = 'asc'.freeze
    Descending = 'desc'.freeze
  end
end
