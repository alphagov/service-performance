require 'rails_helper'

RSpec.describe ServiceMetrics, type: :model do
  let(:service) { instance_double(Service) }
  let(:time_period) { instance_double(TimePeriod) }

  describe '#metrics' do
    let(:root) { service }

    context "grouped by service" do
      it_behaves_like 'uses the correct child entites, depending on the group' do
        let(:children) { [service] }
        let(:group) { Metrics::Group::Service }
      end
    end
  end
end
