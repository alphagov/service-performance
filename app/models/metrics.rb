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

    Name = Sorter.new('name', name: 'name', keypath: [:name])
    TransactionsReceived = Sorter.new(Items::TransactionsReceived, name: 'transactions received', keypath: [:transactions_received, :total])
    TransactionsReceivedOnline = Sorter.new(Items::TransactionsReceivedOnline, name: 'transactions received (online)', keypath: [:transactions_received, :online])
    TransactionsReceivedPhone = Sorter.new(Items::TransactionsReceivedPhone, name: 'transactions received (phone)', keypath: [:transactions_received, :phone])
    TransactionsReceivedPaper = Sorter.new(Items::TransactionsReceivedPaper, name: 'transactions received (paper)', keypath: [:transactions_received, :paper])
    TransactionsReceivedFaceToFace = Sorter.new(Items::TransactionsReceivedFaceToFace, name: 'transactions received (face to face)', keypath: [:transactions_received, :face_to_face])
    TransactionsReceivedOther = Sorter.new(Items::TransactionsReceivedOther, name: 'transactions received (other)', keypath: [:transactions_received, :other])

    TransactionsEndingInOutcome = Sorter.new(Items::TransactionsEndingInOutcome, name: 'transactions ending in an outcome', keypath: [:transactions_with_outcome, :count])
    TransactionsEndingInOutcomeWithIntendedOutcome = Sorter.new(Items::TransactionsEndingInOutcomeWithIntendedOutcome,
      name: "transactions ending in the user's intended outcome",
      keypath: [:transactions_with_outcome, :count_with_intended_outcome])

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
