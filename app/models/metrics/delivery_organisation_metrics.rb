class DeliveryOrganisationMetrics < Metrics
  def self.valid_group_bys
    [GroupBy::DELIVERY_ORGANISATION, GroupBy::SERVICE]
  end

  def entities
    case group_by
    when GroupBy::DELIVERY_ORGANISATION
      [root]
    when GroupBy::SERVICE
      root.services
    end
  end
end
