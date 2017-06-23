class DepartmentMetrics < Metrics
  def self.valid_group_bys
    [GroupBy::Department, GroupBy::DeliveryOrganisation, GroupBy::Service]
  end

  def entities
    case group_by
    when GroupBy::Department
      [root]
    when GroupBy::DeliveryOrganisation
      root.delivery_organisations
    when GroupBy::Service
      root.services
    end
  end
end
