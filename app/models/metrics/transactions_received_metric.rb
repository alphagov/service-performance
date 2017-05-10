class TransactionsReceivedMetric < Metric

  type 'transactions-received'

  # Transactions are split by the channel through which they’re received.
  # The channel is the initial method of contact even if additional information
  # is collected in other ways afterwards.
  # attribute :total

  # Transactions received online. Doesn’t include services where you use an
  # online tool to fill out a paper form or transactions received via web chat.
  attribute :online

  # Transactions received via the phone. Doesn’t include IVR or purely
  # informational calls that don’t affect the outcome of a transaction.
  attribute :phone

  # Transactions received via a paper form. The form can be sent in any way
  # including by post, email, fax or uploading.
  attribute :paper

  # The transaction must be received through a face-to-face meeting with
  # someone working for the service. Doesn’t include handing in a paper form
  # in person.
  attribute :face_to_face

  # Any other way the user provides the information needed to complete a
  # transaction that doesn’t fit into the Online, Phone, Paper and
  # Face-to-face channels.
  attribute :other

end
