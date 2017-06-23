require 'rails_helper'

RSpec.describe ServiceMetrics, type: :model do
  let(:service) { instance_double(Service) }
  let(:time_period) { instance_double(TimePeriod) }

  describe '#metrics' do
    let(:root) { service }

    context "grouped by service" do
      it_behaves_like 'uses the correct child entites, depending on the group by setting' do
        let(:children) { [service] }
        let(:group_by) { Metrics::GroupBy::Service }
      end
    end
  end
end
