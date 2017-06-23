class DeliveryOrganisationMetricsPresenter < MetricsPresenter
  def initialize(client:, delivery_organisation:, group_by: group_by)
    delivery_organisation = client.delivery_organisation(delivery_organisation)
    super(delivery_organisation, client: client, group_by: group_by)
  end

  def has_departments?
    false
  end

  def has_delivery_organisations?
    false
  end
end
