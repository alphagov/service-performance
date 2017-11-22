require 'rails_helper'

RSpec.describe Metric, type: :model do
  class CustomMetric < Metric
    define do
      item :channel_a, from: ->(metric) { metric.channel_a }, applicable: ->(metric) { metric.channel_a_applicable }
      item :channel_b, from: ->(metric) { metric.channel_b }, applicable: ->(metric) { metric.channel_b_applicable }

      percentage_of :total
    end

    def total
      1000
    end
  end

  let(:channel_a_completeness) { instance_double(Completeness) }
  let(:channel_b_completeness) { instance_double(Completeness) }

  describe '#initialize' do
    it 'initializes the metric items & completeness objects' do
      metric = CustomMetric.new(channel_a: 5, channel_a_completeness: channel_a_completeness, channel_b: 10, channel_b_completeness: channel_b_completeness)
      expect(metric.channel_a).to eq(5)
      expect(metric.channel_a_completeness).to eq(channel_a_completeness)
      expect(metric.channel_b).to eq(10)
      expect(metric.channel_b_completeness).to eq(channel_b_completeness)
    end

    it 'requires all metric items as keyword arguments' do
      expect {
        CustomMetric.new
      }.to raise_error(ArgumentError, 'missing keywords: channel_a, channel_b, channel_a_completeness, channel_b_completeness')

      expect {
        CustomMetric.new(channel_a: 0, channel_a_completeness: channel_a_completeness)
      }.to raise_error(ArgumentError, 'missing keywords: channel_b, channel_b_completeness')
    end
  end

  describe '.from_metrics' do
    it 'extracts values from a monthly service metrics object, using the `from` proc' do
      metrics = double('metrics', channel_a: 10, channel_b: 20)

      metric = CustomMetric.from_metrics(metrics)
      expect(metric.channel_a).to eq(10)
      expect(metric.channel_b).to eq(20)
    end

    it "sets the values as NOT_APPLICABLE if they're nil and not applicable" do
      # Neither metric items are applicable, but if a value has been assigned,
      # it takes precedence.
      metrics = double('metrics', channel_a: 10, channel_a_applicable: false, channel_b: nil, channel_b_applicable: false)

      metric = CustomMetric.from_metrics(metrics)
      expect(metric.channel_a).to eq(10)
      expect(metric.channel_b).to eq(Metric::NOT_APPLICABLE)
    end

    it "sets the values as NOT_PROVIDED if they're nil and applicable" do
      metrics = double('metrics', channel_a: 15, channel_a_applicable: true, channel_b: nil, channel_b_applicable: true)

      metric = CustomMetric.from_metrics(metrics)
      expect(metric.channel_a).to eq(15)
      expect(metric.channel_b).to eq(Metric::NOT_PROVIDED)
    end

    describe 'completeness' do
      it 'has completeness of 0/0 for a NOT_APPLICABLE value' do
        metrics = double('metrics', channel_a: nil, channel_a_applicable: false, channel_b: 20)
        metric = CustomMetric.from_metrics(metrics)
        expect(metric.channel_a_completeness.actual).to eq(0)
        expect(metric.channel_a_completeness.expected).to eq(0)
      end

      it 'has completeness of 0/1 for a NOT_PROVIDED value' do
        metrics = double('metrics', channel_a: nil, channel_a_applicable: true, channel_b: 20)
        metric = CustomMetric.from_metrics(metrics)
        expect(metric.channel_a_completeness.actual).to eq(0)
        expect(metric.channel_a_completeness.expected).to eq(1)
      end

      it 'has completeness of 1/1 for a value' do
        metrics = double('metrics', channel_a: 10, channel_a_applicable: true, channel_b: 20)
        metric = CustomMetric.from_metrics(metrics)
        expect(metric.channel_a_completeness.actual).to eq(1)
        expect(metric.channel_a_completeness.expected).to eq(1)
      end
    end
  end

  describe '#not_applicable?' do
    it 'returns false if any of the items is applicable' do
      metrics = double('metrics', channel_a: nil, channel_a_applicable: true, channel_b: nil, channel_b_applicable: false)
      metric = CustomMetric.from_metrics(metrics)
      expect(metric).to_not be_not_applicable
    end

    it 'returns true if all of the items are not applicable' do
      metrics = double('metrics', channel_a: nil, channel_a_applicable: false, channel_b: nil, channel_b_applicable: false)
      metric = CustomMetric.from_metrics(metrics)
      expect(metric).to be_not_applicable
    end
  end

  describe '#not_provided?' do
    it 'returns false if the metric is not applicable' do
      metrics = double('metrics', channel_a: nil, channel_a_applicable: false, channel_b: nil, channel_b_applicable: false)
      metric = CustomMetric.from_metrics(metrics)
      expect(metric).to be_not_applicable
      expect(metric).to_not be_not_provided
    end

    it 'returns false if any metric is provided' do
      metrics = double('metrics', channel_a: 10, channel_a_applicable: true, channel_b: nil, channel_b_applicable: true)
      metric = CustomMetric.from_metrics(metrics)
      expect(metric).to_not be_not_provided
    end

    it 'returns true if all of the values are not provided' do
      metrics = double('metrics', channel_a: nil, channel_a_applicable: true, channel_b: nil, channel_b_applicable: true)
      metric = CustomMetric.from_metrics(metrics)
      expect(metric).to be_not_provided
    end

    it 'returns true if all of the values are either not provided OR not applicable' do
      metrics = double('metrics', channel_a: nil, channel_a_applicable: true, channel_b: nil, channel_b_applicable: false)
      metric = CustomMetric.from_metrics(metrics)
      expect(metric).to be_not_provided
    end
  end

  describe '#+ (addition)' do
    it 'sums value items' do
      metrics1 = double('metrics', channel_a: 10, channel_a_applicable: true, channel_b: 40, channel_b_applicable: true)
      metrics2 = double('metrics', channel_a: 20, channel_a_applicable: true, channel_b: 50, channel_b_applicable: true)

      metric1 = CustomMetric.from_metrics(metrics1)
      metric2 = CustomMetric.from_metrics(metrics2)

      result = metric1 + metric2
      expect(result.channel_a).to eq(30)
      expect(result.channel_b).to eq(90)
    end

    it 'two NOT_APPLICABLE items, result in a NOT_APPLICABLE value' do
      metrics1 = double('metrics', channel_a: nil, channel_a_applicable: false, channel_b: nil, channel_b_applicable: false)
      metrics2 = double('metrics', channel_a: nil, channel_a_applicable: false, channel_b: nil, channel_b_applicable: false)

      metric1 = CustomMetric.from_metrics(metrics1)
      metric2 = CustomMetric.from_metrics(metrics2)

      result = metric1 + metric2
      expect(result.channel_a).to eq(Metric::NOT_APPLICABLE)
      expect(result.channel_b).to eq(Metric::NOT_APPLICABLE)
    end

    it 'two NOT_PROVIDED items, result in a NOT_PROVIDED value' do
      metrics1 = double('metrics', channel_a: nil, channel_a_applicable: true, channel_b: nil, channel_b_applicable: true)
      metrics2 = double('metrics', channel_a: nil, channel_a_applicable: true, channel_b: nil, channel_b_applicable: true)

      metric1 = CustomMetric.from_metrics(metrics1)
      metric2 = CustomMetric.from_metrics(metrics2)

      result = metric1 + metric2
      expect(result.channel_a).to eq(Metric::NOT_PROVIDED)
      expect(result.channel_b).to eq(Metric::NOT_PROVIDED)
    end

    it 'with a NOT_APPLICABLE item and a NOT_PROVIDED item, results in a NOT_PROVIDED value' do
      metrics1 = double('metrics', channel_a: nil, channel_a_applicable: false, channel_b: nil, channel_b_applicable: false)
      metrics2 = double('metrics', channel_a: nil, channel_a_applicable: true, channel_b: nil, channel_b_applicable: true)

      metric1 = CustomMetric.from_metrics(metrics1)
      metric2 = CustomMetric.from_metrics(metrics2)

      result = metric1 + metric2
      expect(result.channel_a).to eq(Metric::NOT_PROVIDED)
      expect(result.channel_b).to eq(Metric::NOT_PROVIDED)
    end

    it 'sums the items completeness values' do
      metrics1 = double('metrics', channel_a: 10, channel_a_applicable: true, channel_b: 40, channel_b_applicable: true)
      metrics2 = double('metrics', channel_a: nil, channel_a_applicable: true, channel_b: nil, channel_b_applicable: false)

      metric1 = CustomMetric.from_metrics(metrics1)
      metric2 = CustomMetric.from_metrics(metrics2)

      result = metric1 + metric2
      expect(result.channel_a_completeness.actual).to eq(1)
      expect(result.channel_a_completeness.expected).to eq(2)
      expect(result.channel_b_completeness.actual).to eq(1)
      expect(result.channel_b_completeness.expected).to eq(1)
    end
  end

  describe 'percentages' do
    it 'defines a percentage accessor for each metric item' do
      metrics = double('metrics', channel_a: 400, channel_a_applicable: true, channel_b: 600, channel_b_applicable: true)
      metric = CustomMetric.from_metrics(metrics)

      expect(metric.channel_a_percentage).to eq(40.0)
      expect(metric.channel_b_percentage).to eq(60.0)
    end

    it 'returns NOT_APPLICABLE if the value is not applicable' do
      metrics = double('metrics', channel_a: nil, channel_a_applicable: false, channel_b: 600, channel_b_applicable: true)
      metric = CustomMetric.from_metrics(metrics)

      expect(metric.channel_a_percentage).to eq(Metric::NOT_APPLICABLE)
    end

    it 'returns NOT_PROVIDED if the value is not provided' do
      metrics = double('metrics', channel_a: nil, channel_a_applicable: true, channel_b: 600, channel_b_applicable: true)
      metric = CustomMetric.from_metrics(metrics)

      expect(metric.channel_a_percentage).to eq(Metric::NOT_PROVIDED)
    end
  end
end
