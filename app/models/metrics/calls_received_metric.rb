class CallsReceivedMetric < Metric

  type 'calls-received'

  # The total number of calls to the service. These calls should be categorised
  # into one of four groups based on the thing that triggered the user to
  # contact the service via the phone.
  attribute :total

  # Calls to get advice or guidance about the service.
  attribute :get_information

  # Calls to find out about a decision or action that the user expects the service to take.
  attribute :chase_progress

  # Calls to dispute an instruction or request from the service or to appeal an outcome.
  attribute :challenge_a_decision

  # Calls that don't fit into the three previous categories.
  attribute :other

end
