require 'rails_helper'

RSpec.describe CallsReceivedMetricSerializer, type: :serializer do
  let(:metric) { serializable_double(CallsReceivedMetric, total: 1000, get_information: 456, chase_progress: 789, challenge_a_decision: 876, other: 543, sampled: false, sampled_total: 200, perform_transaction: 100, completeness: {}) }
  subject(:serializer) { CallsReceivedMetricSerializer.new(metric) }

  it 'serializes a aggregated calls received metric' do
    expect {
      serializer.to_json
    }.to_not raise_error
  end

  describe '#total', attribute: :total do
    it_behaves_like 'serialized metric attribute'
  end

  describe '#get_information', attribute: :get_information do
    it_behaves_like 'serialized metric attribute'
  end

  describe '#chase_progress', attribute: :chase_progress do
    it_behaves_like 'serialized metric attribute'
  end

  describe '#challenge_a_decision', attribute: :challenge_a_decision do
    it_behaves_like 'serialized metric attribute'
  end

  describe '#perform_transaction', attribute: :perform_transaction do
    it_behaves_like 'serialized metric attribute'
  end

  describe '#other', attribute: :other do
    it_behaves_like 'serialized metric attribute'
  end
end
