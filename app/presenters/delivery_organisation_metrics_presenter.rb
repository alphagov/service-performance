class DeliveryOrganisationMetricsPresenter < MetricsPresenter
  def initialize(client:, delivery_organisation:, group: group)
    delivery_organisation = client.delivery_organisation(delivery_organisation)
    super(delivery_organisation, client: client, group: group)
  end

  def has_departments?
    false
  end

  def has_delivery_organisations?
    false
  end
end
