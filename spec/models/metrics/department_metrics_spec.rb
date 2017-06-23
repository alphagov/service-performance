require 'rails_helper'

RSpec.describe DepartmentMetrics, type: :model do
  let(:department) { instance_double(Department) }
  let(:time_period) { instance_double(TimePeriod) }

  describe '#metrics' do
    let(:root) { department }

    context "grouped by department" do
      it_behaves_like 'uses the correct child entites, depending on the group by setting' do
        let(:children) { [department] }
        let(:group_by) { Metrics::GroupBy::Department }
      end
    end

    context "grouped by delivery organistaion" do
      it_behaves_like 'uses the correct child entites, depending on the group by setting' do
        let(:children) { [double(:delivery_organisation_1), double(:delivery_organisation_2)] }
        let(:group_by) { Metrics::GroupBy::DeliveryOrganisation }

        before do
          allow(root).to receive(:delivery_organisations) { children }
        end
      end
    end

    context "grouped by service" do
      it_behaves_like 'uses the correct child entites, depending on the group by setting' do
        let(:children) { [double(:service_1), double(:service_2)] }
        let(:group_by) { Metrics::GroupBy::Service }

        before do
          allow(root).to receive(:services) { children }
        end
      end
    end
  end
end
