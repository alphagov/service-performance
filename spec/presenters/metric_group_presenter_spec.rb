require 'rails_helper'

RSpec.describe MetricGroupPresenter, type: :presenter do
  let(:entity) { double('entity') }
  let(:metric) { double('metric') }
  let(:metrics) { [metric] }
  let(:metric_group) { instance_double(Metrics::MetricGroup, entity: entity, metrics: metrics) }
  subject(:presenter) { described_class.new(metric_group) }

  describe MetricGroupPresenter::Totals do
    describe '#entity' do
      it 'returns a partial path to display the metric group header' do
        expect(presenter.entity.to_partial_path).to eq('metric_groups/header/total')
      end
    end

    describe '#totals?' do
      it { expect(presenter.totals?).to be_truthy }
    end
  end

  describe '#entity' do
    it 'returns a partial path to display the metric group header' do
      allow(entity).to receive_message_chain(:class, :name) { 'FakeEntity' }
      expect(presenter.entity.to_partial_path).to eq('metric_groups/header/fake_entity')
    end
  end

  describe '#metrics' do
    it 'extends metrics with a partial path to display the metric' do
      allow(metric).to receive_message_chain(:class, :name) { 'FakeMetric' }
      allow(metric).to receive(:not_provided?) { false }
      allow(metric).to receive(:not_applicable?) { false }
      expect(presenter.metrics.first.to_partial_path).to eq('metrics/fake_metric')
    end
  end

  describe '#name' do
    it 'delegates to the entity name' do
      allow(entity).to receive(:name) { 'Delegated Name' }
      expect(presenter.name).to eq('Delegated Name')
    end
  end

  describe '#delivery_organisations_count' do
    it 'delegates to the entity if entity respond to #delivery_organisations_count' do
      allow(entity).to receive(:delivery_organisations_count) { 53 }
      expect(presenter.delivery_organisations_count).to eq(53)
    end

    it "returns nil if the entity doesn't respond to #delivery_organisations_count" do
      expect(presenter.delivery_organisations_count).to be_nil
    end
  end

  describe '#services_count' do
    it 'delegates to the entity if entity respond to #services_count' do
      allow(entity).to receive(:services_count) { 39 }
      expect(presenter.services_count).to eq(39)
    end

    it "returns nil if the entity doesn't respond to #services_count" do
      expect(presenter.services_count).to be_nil
    end
  end

  describe '#collapsed?' do
    it "isn't collapsed by default" do
      expect(presenter).to_not be_collapsed
    end

    it "can be set to collapsed" do
      presenter = MetricGroupPresenter.new(metric_group, collapsed: true)
      expect(presenter).to be_collapsed
    end
  end

  describe '#totals?' do
    it { expect(presenter.totals?).to be_falsey }
  end
end
