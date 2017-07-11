RSpec.shared_examples_for 'metric group header' do
  let(:entity) { double('entity', key: 'ABC123') }
  let(:metric_group) { instance_double(MetricGroupPresenter, name: 'Metric Group Name', entity: entity, delivery_organisations_count: 83, services_count: 93) }

  def render
    super(partial: partial, locals: { metric_group: metric_group })
  end

  it "has a 'm-metric-group-header' container"  do |example|
    render
    expect(rendered).to have_selector('.m-metric-group-header')
  end

  it 'has a heading' do
    render
    expect(rendered).to have_selector('.m-metric-group-header h2', text: 'Metric Group Name')
  end
end