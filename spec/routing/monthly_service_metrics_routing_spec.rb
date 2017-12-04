require 'rails_helper'

RSpec.describe 'monthly service metrics routing', type: :routing do
  specify 'GET MonthlyServiceMetrics#edit' do
    expect(get: '/publish/services/001/metrics/2017/09').to route_to(
      controller: 'publish_data/monthly_service_metrics',
      action: 'edit',
      service_id: '001',
      year: '2017',
      month: '09',
    )
  end

  specify 'PATCH MonthlyServiceMetrics#edit' do
    expect(patch: '/publish/services/001/metrics/2017/09').to route_to(
      controller: 'publish_data/monthly_service_metrics',
      action: 'update',
      service_id: '001',
      year: '2017',
      month: '09',
    )
  end

  specify 'GET MonthlyServiceMetrics#preview' do
    expect(get: '/publish/services/001/metrics/2017/09/TOKEN/preview').to route_to(
      controller: 'publish_data/monthly_service_metrics',
      action: 'preview',
      service_id: '001',
      year: '2017',
      month: '09',
      publish_token: 'TOKEN'
    )
  end
end
