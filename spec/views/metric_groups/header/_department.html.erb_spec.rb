require 'rails_helper'

RSpec.describe 'metric_groups/header/_department.html.erb', type: :view do
  it_behaves_like 'metric group header' do
    let(:partial) { 'metric_groups/header/department' }
  end
end
