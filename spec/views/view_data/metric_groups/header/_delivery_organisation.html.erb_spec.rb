require 'rails_helper'

RSpec.describe 'view_data/metric_groups/header/_delivery_organisation.html.erb', type: :view do
  it_behaves_like 'metric group header' do
    let(:partial) { 'view_data/metric_groups/header/delivery_organisation' }
  end
end
