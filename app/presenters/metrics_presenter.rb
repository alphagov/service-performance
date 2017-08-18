class MetricsPresenter
  def initialize(entity, client:, group_by:, order: nil, order_by: nil)
    @entity = entity
    @client = client

    @group_by = group_by
    @order_by = order_by || Metrics::OrderBy::Name.identifier
    @order = order || Metrics::Order::Descending
    @order = Metrics::Order::Ascending if @order_by == Metrics::OrderBy::Name.identifier

    @sorter = Metrics::OrderBy.fetch(@order_by)
  end

  attr_reader :group_by, :order_by, :order

  def group_by_screen_name
    case group_by
    when Metrics::Group::Department
      'department'
    when Metrics::Group::DeliveryOrganisation
      'delivery organisation'
    when Metrics::Group::Service
      'service'
    else
      'by name'
    end
  end

  def organisation_name
    entity.name
  end

  def metric_groups
    @metric_groups ||= begin
      metric_groups = data.metric_groups
                        .map { |metric_group| MetricGroupPresenter.new(metric_group, collapsed: collapsed?) }
                        .sort_by(&sorter)
      metric_groups.reverse! if order == Metrics::Order::Descending

      if order_by == Metrics::OrderBy::Name.identifier
        metric_groups.unshift(totals_metric_group_presenter)
      elsif order == Metrics::Order::Ascending
        metric_groups.push(totals_metric_group_presenter)
      elsif order == Metrics::Order::Descending
        metric_groups.unshift(totals_metric_group_presenter)
      end

      metric_groups
    end
  end

  def sorting_by_name?
    @order_by == "name"
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
    end
  end

  def delivery_organisations_count
    if has_delivery_organisations?
      entity.delivery_organisations_count
    end
  end

  def services_count
    if has_services?
      entity.services_count
    end
  end

  def collapsed?
    order_by != Metrics::OrderBy::Name.identifier
  end

private

  attr_reader :client, :entity, :sorter

  def data
    @data ||= client.metrics(entity, group_by: group_by)
  end

  def totals_metric_group_presenter
    @totals_metric_group_presenter ||= MetricGroupPresenter::Totals.new(data.totals, collapsed: collapsed?)
  end
end
