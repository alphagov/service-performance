class GovernmentMetricsPresenter < MetricsPresenter
  def initialize(client:, group:)
    government = client.government
    super(government, client: client, group: group)
  end

  def organisation_name
    'UK government'
  end
end
