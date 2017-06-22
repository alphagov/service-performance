class DepartmentMetrics < Metrics
  def self.supported_groups
    [Group::Department, Group::DeliveryOrganisation, Group::Service]
  end

  def entities
    case group
    when Group::Department
      [root]
    when Group::DeliveryOrganisation
      root.delivery_organisations
    when Group::Service
      root.services
    end
  end
end
