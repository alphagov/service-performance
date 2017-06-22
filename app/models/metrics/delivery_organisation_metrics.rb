class DeliveryOrganisationMetrics < Metrics
  def self.supported_groups
    [Group::DeliveryOrganisation, Group::Service]
  end

  def entities
    case group
    when Group::DeliveryOrganisation
      [root]
    when Group::Service
      root.services
    end
  end
end
