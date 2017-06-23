class MetricsPresenter
  def initialize(entity, client:, group_by:)
    @entity = entity
    @metric_groups = client.metric_groups(@entity, group_by: group_by)
  end

  def organisation_name
    entity.name
  end

  def groups
    @metric_groups.map do |metric_group|
      MetricGroupPresenter.new(metric_group)
    end
  end

  def has_departments?
    true
  end

  def has_delivery_organisations?
    true
  end
  
  def has_services?
    true
  end

  def departments_count
    if has_departments?
      entity.departments_count
    else
      nil
    end
  end
  
  def delivery_organisations_count
    if has_delivery_organisations?
      entity.delivery_organisations_count
    else
      nil
    end
  end
  
  def services_count
    if has_services?
      entity.services_count
    else
      nil
    end
  end

  private

  attr_reader :entity
end
