class GovernmentMetrics < Metrics
  def self.valid_group_bys
    [GroupBy::GOVERNMENT, GroupBy::DEPARTMENT, GroupBy::DELIVERY_ORGANISATION, GroupBy::SERVICE]
  end

  def entities
    case group_by
    when GroupBy::GOVERNMENT
      [root]
    when GroupBy::DEPARTMENT
      root.departments
    when GroupBy::DELIVERY_ORGANISATION
      root.delivery_organisations
    when GroupBy::SERVICE
      root.services
    end
  end
end
