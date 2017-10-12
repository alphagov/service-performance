require 'rails_helper'

RSpec.describe 'monthly service metrics routing', type: :routing do
  specify 'GET MonthlyServiceMetrics#edit' do
    expect(get: '/publish/services/001/metrics/2017/09').to route_to(
      controller: 'monthly_service_metrics',
      action: 'edit',
      service_id: '001',
      year: '2017',
      month: '09',
    )
  end

  specify 'PATCH MonthlyServiceMetrics#edit' do
    expect(patch: '/publish/services/001/metrics/2017/09').to route_to(
      controller: 'monthly_service_metrics',
      action: 'update',
      service_id: '001',
      year: '2017',
      month: '09',
    )
  end
end
