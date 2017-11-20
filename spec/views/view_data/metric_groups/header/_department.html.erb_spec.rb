require 'rails_helper'

RSpec.describe 'view_data/metric_groups/header/_department.html.erb', type: :view do
  it_behaves_like 'metric group header' do
    let(:partial) { 'view_data/metric_groups/header/department' }
  end
end
