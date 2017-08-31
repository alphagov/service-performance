RSpec.shared_examples_for 'serialized metric attribute' do
  let(:attribute) { |example| example.metadata[:attribute] }

  it "attribute isn't present if not applicable" do
    allow(metric).to receive(attribute) { Metric::NOT_APPLICABLE }

    expect(serializer.attributes[attribute]).to be_nil
  end

  it "attribute is present, but nil if not provided" do
    allow(metric).to receive(attribute) { Metric::NOT_PROVIDED }

    expect(serializer.attributes[attribute]).to be_nil
  end

  it "attribute is present, and populated if provided" do
    allow(metric).to receive(attribute) { 1_000_000 }

    expect(serializer.attributes[attribute]).to eq(1_000_000)
  end
end
