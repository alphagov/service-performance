class DepartmentMetrics < Metrics
  def self.valid_group_bys
    [GroupBy::DEPARTMENT, GroupBy::DELIVERY_ORGANISATION, GroupBy::SERVICE]
  end

  def entities
    case group_by
    when GroupBy::DEPARTMENT
      [root]
    when GroupBy::DELIVERY_ORGANISATION
      root.delivery_organisations
    when GroupBy::SERVICE
      root.services
    end
  end
end
