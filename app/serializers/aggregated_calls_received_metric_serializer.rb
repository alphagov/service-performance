class AggregatedCallsReceivedMetricSerializer < ActiveModel::Serializer
  attributes :type, :total, :get_information, :chase_progress,
             :challenge_a_decision, :other, :sampled, :sampled_total

  def type
    'calls-received'
  end
end
