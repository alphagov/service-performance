require 'rails_helper'

RSpec.describe TransactionsReceivedMetricSerializer, type: :serializer do
  let(:metric) { serializable_double(TransactionsReceivedMetric, total: 1000, online: 456, phone: 789, paper: 876, face_to_face: 843, other: 543, completeness: {}) }
  subject(:serializer) { TransactionsReceivedMetricSerializer.new(metric) }

  it 'serializes a aggregated transactions received metric' do
    expect {
      serializer.to_json
    }.to_not raise_error
  end

  describe '#total', attribute: :total do
    it_behaves_like 'serialized metric attribute'
  end

  describe '#online', attribute: :online do
    it_behaves_like 'serialized metric attribute'
  end

  describe '#phone', attribute: :phone do
    it_behaves_like 'serialized metric attribute'
  end

  describe '#paper', attribute: :paper do
    it_behaves_like 'serialized metric attribute'
  end

  describe '#face_to_face', attribute: :face_to_face do
    it_behaves_like 'serialized metric attribute'
  end

  describe '#other', attribute: :other do
    it_behaves_like 'serialized metric attribute'
  end
end
