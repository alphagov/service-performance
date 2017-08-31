require 'rails_helper'

RSpec.describe AggregatedTransactionsWithOutcomeMetricSerializer, type: :serializer do
  let(:metric) {
    double = instance_double(AggregatedTransactionsWithOutcomeMetric, total: 123, with_intended_outcome: 456)
    allow(double).to receive(:read_attribute_for_serialization) do |*args|
      double.send(*args)
    end
    double
  }
  subject(:serializer) { AggregatedTransactionsWithOutcomeMetricSerializer.new(metric) }

  it 'serializes a aggregated transactions with outcome metric' do
    expect {
      serializer.to_json
    }.to_not raise_error
  end

  describe '#total' do
    it "attribute isn't present if not applicable" do
      allow(metric).to receive(:total) { Metric::NOT_APPLICABLE }

      expect(serializer.attributes[:total]).to be_nil
    end

    it "attribute is present, but nil if not provided" do
      allow(metric).to receive(:total) { Metric::NOT_PROVIDED }

      expect(serializer.attributes[:total]).to be_nil
    end

    it "attribute is present, and populated if provided" do
      allow(metric).to receive(:total) { 1_000_000 }

      expect(serializer.attributes[:total]).to eq(1_000_000)
    end
  end

  describe '#with_intended_outcome' do
    it "attribute isn't present if not applicable" do
      allow(metric).to receive(:with_intended_outcome) { Metric::NOT_APPLICABLE }

      expect(serializer.attributes[:with_intended_outcome]).to be_nil
    end

    it "attribute is present, but nil if not provided" do
      allow(metric).to receive(:with_intended_outcome) { Metric::NOT_PROVIDED }

      expect(serializer.attributes[:with_intended_outcome]).to be_nil
    end

    it "attribute is present, and populated if provided" do
      allow(metric).to receive(:with_intended_outcome) { 1_000_000 }

      expect(serializer.attributes[:with_intended_outcome]).to eq(1_000_000)
    end
  end
end
