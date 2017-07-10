module Metrics
  module Group
    Government = 'government'
    Department = 'department'
    DeliveryOrganisation = 'delivery_organisation'
    Service = 'service'
  end

  module OrderBy
    private
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
    TransactionsReceived = Sorter.new('transactions-received', name: 'transactions received', keypath: [:transactions_received, :total])
    TransactionsReceivedOnline = Sorter.new('transactions-received-online', name: 'transactions received (online)', keypath: [:transactions_received, :online])
    TransactionsReceivedPhone = Sorter.new('transactions-received-phone', name: 'transactions received (phone)', keypath: [:transactions_received, :phone])
    TransactionsReceivedPaper = Sorter.new('transactions-received-paper', name: 'transactions received (paper)', keypath: [:transactions_received, :paper])
    TransactionsReceivedFaceToFace = Sorter.new('transactions-received-face-to-face', name: 'transactions received (face to face)', keypath: [:transactions_received, :face_to_face])
    TransactionsReceivedOther = Sorter.new('transactions-received-other', name: 'transactions received (other)', keypath: [:transactions_received, :other])

    TransactionsEndingInOutcome = Sorter.new('transactions-ending-in-outcome', name: 'transactions ending in an outcome', keypath: [:transactions_with_outcome, :count])
    TransactionsEndingInOutcomeWithIntendedOutcome = Sorter.new('transactions-ending-in-outcome-with-intended-outcome',
      name: "transactions ending in the user's intended outcome",
      keypath: [:transactions_with_outcome, :count_with_intended_outcome]
    )

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
    ]

    def self.fetch(identifier)
      ALL.index_by(&:identifier).fetch(identifier)
    end
  end

  module Order
    Ascending = 'asc'
    Descending = 'desc'
  end
end
