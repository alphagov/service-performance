class GovernmentMetrics < Metrics
  def self.valid_group_bys
    [GroupBy::Government, GroupBy::Department, GroupBy::DeliveryOrganisation, GroupBy::Service]
  end

  def entities
    case group_by
    when GroupBy::Government
      [root]
    when GroupBy::Department
      root.departments
    when GroupBy::DeliveryOrganisation
      root.delivery_organisations
    when GroupBy::Service
      root.services
    end
  end
end
