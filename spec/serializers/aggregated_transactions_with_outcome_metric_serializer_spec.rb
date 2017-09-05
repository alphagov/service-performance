require 'rails_helper'

RSpec.describe AggregatedTransactionsWithOutcomeMetricSerializer, type: :serializer do
  let(:metric) { serializable_double(AggregatedTransactionsWithOutcomeMetric, total: 123, with_intended_outcome: 456, completeness: {}) }
  subject(:serializer) { AggregatedTransactionsWithOutcomeMetricSerializer.new(metric) }

  it 'serializes a aggregated transactions with outcome metric' do
    expect {
      serializer.to_json
    }.to_not raise_error
  end

  describe '#total', attribute: :total do
    it_behaves_like 'serialized metric attribute'
  end

  describe '#with_intended_outcome', attribute: :with_intended_outcome do
    it_behaves_like 'serialized metric attribute'
  end
end
