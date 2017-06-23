class GovernmentMetricsPresenter < MetricsPresenter
  def initialize(client:, group_by:)
    government = client.government
    super(government, client: client, group_by: group_by)
  end

  def organisation_name
    'UK government'
  end
end
