class AggregatedCallsReceivedMetricSerializer < ActiveModel::Serializer
  attributes :type, :total, :get_information, :chase_progress,
             :challenge_a_decision, :other

  def type
    'calls-received'
  end
end
