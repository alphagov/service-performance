class GovernmentMetrics < Metrics
  def self.supported_groups
    [Group::Government, Group::Department, Group::DeliveryOrganisation, Group::Service]
  end

  def entities
    case group
    when Group::Government
      [root]
    when Group::Department
      root.departments
    when Group::DeliveryOrganisation
      root.delivery_organisations
    when Group::Service
      root.services
    end
  end
end
