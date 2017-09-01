module Metrics
  module Group
    Government = 'government'.freeze
    Department = 'department'.freeze
    DeliveryOrganisation = 'delivery_organisation'.freeze
    Service = 'service'.freeze
  end

  module Items
    TransactionsReceived = 'transactions-received'.freeze
    TransactionsReceivedOnline = 'transactions-received-online'.freeze
    TransactionsReceivedPhone = 'transactions-received-phone'.freeze
    TransactionsReceivedPaper = 'transactions-received-paper'.freeze
    TransactionsReceivedFaceToFace = 'transactions-received-face-to-face'.freeze
    TransactionsReceivedOther = 'transactions-received-other'.freeze

    TransactionsEndingInOutcome = 'transactions-ending-in-outcome'.freeze
    TransactionsEndingInOutcomeWithIntendedOutcome = 'transactions-ending-in-outcome-with-intended-outcome'.freeze

    CallsReceived = 'calls-received'.freeze
    CallsReceivedGetInformation = 'calls-received-get-information'.freeze
    CallsReceivedChaseProgress = 'calls-received-chase-progress'.freeze
    CallsReceivedChallengeADecision = 'calls-received-challenge-a-decision'.freeze
    CallsReceivedOther = 'calls-received-other'.freeze
  end

  module OrderBy
    class Sorter
      def initialize(identifier, name:, keypath:)
        @identifier = identifier
        @name = name
        @keypath = keypath
      end

      attr_reader :identifier, :name

      def to_proc
        ->(metric_group) { @keypath.reduce(metric_group, :send) }
      end
    end

    class MetricSorter < Sorter
      include GovernmentServiceDataAPI::MetricStatus

      def to_proc
        ->(metric_group) do
          value = super.(metric_group)
          if value.in? [NOT_PROVIDED, NOT_APPLICABLE]
            0
          else
            value
          end
        end
      end
    end

    Name = Sorter.new('name', name: 'name', keypath: [:name])
    TransactionsReceived = MetricSorter.new(Items::TransactionsReceived, name: 'transactions received', keypath: [:transactions_received, :total])
    TransactionsReceivedOnline = MetricSorter.new(Items::TransactionsReceivedOnline, name: 'transactions received (online)', keypath: [:transactions_received, :online])
    TransactionsReceivedPhone = MetricSorter.new(Items::TransactionsReceivedPhone, name: 'transactions received (phone)', keypath: [:transactions_received, :phone])
    TransactionsReceivedPaper = MetricSorter.new(Items::TransactionsReceivedPaper, name: 'transactions received (paper)', keypath: [:transactions_received, :paper])
    TransactionsReceivedFaceToFace = MetricSorter.new(Items::TransactionsReceivedFaceToFace, name: 'transactions received (face to face)', keypath: [:transactions_received, :face_to_face])
    TransactionsReceivedOther = MetricSorter.new(Items::TransactionsReceivedOther, name: 'transactions received (other)', keypath: [:transactions_received, :other])

    TransactionsEndingInOutcome = MetricSorter.new(Items::TransactionsEndingInOutcome, name: 'transactions ending in an outcome', keypath: [:transactions_with_outcome, :count])
    TransactionsEndingInOutcomeWithIntendedOutcome = MetricSorter.new(Items::TransactionsEndingInOutcomeWithIntendedOutcome,
      name: "transactions ending in the user's intended outcome",
      keypath: [:transactions_with_outcome, :count_with_intended_outcome])

    CallsReceived = MetricSorter.new(Items::CallsReceived, name: 'calls received', keypath: [:calls_received, :total])
    CallsReceivedGetInformation = MetricSorter.new(Items::CallsReceivedGetInformation, name: 'calls received (get information)', keypath: [:calls_received, :get_information])
    CallsReceivedChaseProgress = MetricSorter.new(Items::CallsReceivedChaseProgress, name: 'calls received (chase progress)', keypath: [:calls_received, :chase_progress])
    CallsReceivedChallengeADecision = MetricSorter.new(Items::CallsReceivedChallengeADecision, name: 'calls received (challenge a decision)', keypath: [:calls_received, :challenge_a_decision])
    CallsReceivedOther = MetricSorter.new(Items::CallsReceivedOther, name: 'calls received (other)', keypath: [:calls_received, :other])

    ALL = [
      Name,
      TransactionsReceived,
      TransactionsReceivedOnline,
      TransactionsReceivedPhone,
      TransactionsReceivedPaper,
      TransactionsReceivedFaceToFace,
      TransactionsReceivedOther,
      TransactionsEndingInOutcome,
      TransactionsEndingInOutcomeWithIntendedOutcome,
      CallsReceived,
      CallsReceivedGetInformation,
      CallsReceivedChaseProgress,
      CallsReceivedChallengeADecision,
      CallsReceivedOther,
    ].freeze

    def self.fetch(identifier)
      ALL.index_by(&:identifier).fetch(identifier)
    end
  end

  module Order
    Ascending = 'asc'.freeze
    Descending = 'desc'.freeze
  end
end
