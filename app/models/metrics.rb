module Metrics
  module Group
    Government = 'government'
    Department = 'department'
    DeliveryOrganisation = 'delivery_organisation'
    Service = 'service'
  end

  module Items
    TransactionsReceived = 'transactions-received'
    TransactionsReceivedOnline = 'transactions-received-online'
    TransactionsReceivedPhone = 'transactions-received-phone'
    TransactionsReceivedPaper = 'transactions-received-paper'
    TransactionsReceivedFaceToFace = 'transactions-received-face-to-face'
    TransactionsReceivedOther = 'transactions-received-other'

    TransactionsEndingInOutcome = 'transactions-ending-in-outcome'
    TransactionsEndingInOutcomeWithIntendedOutcome = 'transactions-ending-in-outcome-with-intended-outcome'
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
    TransactionsReceived = Sorter.new(Items::TransactionsReceived, name: 'transactions received', keypath: [:transactions_received, :total])
    TransactionsReceivedOnline = Sorter.new(Items::TransactionsReceivedOnline, name: 'transactions received (online)', keypath: [:transactions_received, :online])
    TransactionsReceivedPhone = Sorter.new(Items::TransactionsReceivedPhone, name: 'transactions received (phone)', keypath: [:transactions_received, :phone])
    TransactionsReceivedPaper = Sorter.new(Items::TransactionsReceivedPaper, name: 'transactions received (paper)', keypath: [:transactions_received, :paper])
    TransactionsReceivedFaceToFace = Sorter.new(Items::TransactionsReceivedFaceToFace, name: 'transactions received (face to face)', keypath: [:transactions_received, :face_to_face])
    TransactionsReceivedOther = Sorter.new(Items::TransactionsReceivedOther, name: 'transactions received (other)', keypath: [:transactions_received, :other])

    TransactionsEndingInOutcome = Sorter.new(Items::TransactionsEndingInOutcome, name: 'transactions ending in an outcome', keypath: [:transactions_with_outcome, :count])
    TransactionsEndingInOutcomeWithIntendedOutcome = Sorter.new(Items::TransactionsEndingInOutcomeWithIntendedOutcome,
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
