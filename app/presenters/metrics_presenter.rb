class MetricsPresenter
  def initialize(entity, client:, group_by:, order: nil, order_by: nil)
    @entity = entity
    @client = client

    @group_by = group_by
    @order_by = order_by || Metrics::OrderBy::Name.identifier
    @order = order || Metrics::Order::Ascending
    @sorter = Metrics::OrderBy.fetch(@order_by)
  end

  attr_reader :group_by, :order_by, :order

  def organisation_name
    entity.name
  end

  def metric_groups
    @metric_groups ||= begin
      metric_groups = client
                        .metric_groups(entity, group_by: group_by)
                        .map { |metric_group| MetricGroupPresenter.new(metric_group) }
                        .sort_by(&sorter)
      metric_groups.reverse! if order == Metrics::Order::Descending
      metric_groups
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

  attr_reader :client, :entity, :sorter
end
