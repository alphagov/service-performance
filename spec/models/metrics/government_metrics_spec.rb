require 'rails_helper'

RSpec.describe GovernmentMetrics, type: :model do
  let(:government) { instance_double(Government) }
  let(:time_period) { instance_double(TimePeriod) }

  describe '#metrics' do
    let(:root) { government }

    context "grouped by government" do
      it_behaves_like 'uses the correct child entites, depending on the group' do
        let(:children) { [government] }
        let(:group) { Metrics::Group::Government }
      end
    end

    context "grouped by department" do
      it_behaves_like 'uses the correct child entites, depending on the group' do
        let(:children) { [double(:department_1), double(:department_2)] }
        let(:group) { Metrics::Group::Department }

        before do
          allow(root).to receive(:departments) { children }
        end
      end
    end

    context "grouped by delivery organistaion" do
      it_behaves_like 'uses the correct child entites, depending on the group' do
        let(:children) { [double(:delivery_organisation_1), double(:delivery_organisation_2)] }
        let(:group) { Metrics::Group::DeliveryOrganisation }

        before do
          allow(root).to receive(:delivery_organisations) { children }
        end
      end
    end

    context "grouped by service" do
      it_behaves_like 'uses the correct child entites, depending on the group' do
        let(:children) { [double(:service_1), double(:service_2)] }
        let(:group) { Metrics::Group::Service }

        before do
          allow(root).to receive(:services) { children }
        end
      end
    end
  end
end
