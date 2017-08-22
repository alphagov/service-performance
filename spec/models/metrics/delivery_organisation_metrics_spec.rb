require 'rails_helper'

RSpec.describe DeliveryOrganisationMetrics, type: :model do
  let(:delivery_organisation) { instance_double(DeliveryOrganisation) }
  let(:time_period) { instance_double(TimePeriod) }

  describe '#metrics' do
    let(:root) { delivery_organisation }

    context "grouped by delivery organistaion" do
      it_behaves_like 'uses the correct child entites, depending on the group by setting' do
        let(:children) { [delivery_organisation] }
        let(:group_by) { Metrics::GroupBy::DELIVERY_ORGANISATION }
      end
    end

    context "grouped by service" do
      it_behaves_like 'uses the correct child entites, depending on the group by setting' do
        let(:children) { [double(:service_1), double(:service_2)] }
        let(:group_by) { Metrics::GroupBy::SERVICE }

        before do
          allow(root).to receive(:services) { children }
        end
      end
    end
  end
end
