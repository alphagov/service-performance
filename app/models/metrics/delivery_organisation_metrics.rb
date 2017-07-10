class DeliveryOrganisationMetrics < Metrics
  def self.valid_group_bys
    [GroupBy::DeliveryOrganisation, GroupBy::Service]
  end

  def entities
    case group_by
    when GroupBy::DeliveryOrganisation
      [root]
    when GroupBy::Service
      root.services
    end
  end
end
