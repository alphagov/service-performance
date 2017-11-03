class MetricsPresenter
  def initialize(entity, client:, group_by:, order: nil, order_by: nil)
    @entity = entity
    @client = client

    @group_by = group_by
    @order_by = order_by
    @selected_metric_sort_attribute = Metrics::Items.get_metric_sort_attribute(order_by)
    @order = order || Metrics::Order::Descending
  end

  attr_reader :group_by, :order_by, :selected_metric_sort_attribute, :order

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

  def show_completeness?
    group_by == Metrics::Group::Service
  end

  def organisation_name
    entity.name
  end

  def metric_groups
    @metric_groups ||= begin
      metric_groups = data.metric_groups
                        .map { |metric_group|
                          v = @selected_metric_sort_attribute.value(metric_group)
                          MetricGroupPresenter.new(metric_group, collapsed: collapsed?, sort_value: v)
                        }
                        .select(&:has_sort_value?)
                        .sort_by(&:sort_value)

      # When sorting by name, we want Descending (the default) to
      # sort A-Z rather than Z-A, but to work as expected for metrics.
      if @selected_metric_sort_attribute == Metrics::Items::Name
        metric_groups.reverse! if order == Metrics::Order::Ascending
      elsif order == Metrics::Order::Descending
        metric_groups.reverse!
      end

      if @selected_metric_sort_attribute == Metrics::Items::Name
        metric_groups.unshift(totals_metric_group_presenter)
      elsif order == Metrics::Order::Ascending
        metric_groups.push(totals_metric_group_presenter)
      elsif order == Metrics::Order::Descending
        metric_groups.unshift(totals_metric_group_presenter)
      end

      metric_groups
    end
  end

  def high_to_low_label
    return "A to Z" if @selected_metric_sort_attribute == Metrics::Items::Name
    "High to Low"
  end

  def low_to_high_label
    return "Z to A" if @selected_metric_sort_attribute == Metrics::Items::Name
    "Low to High"
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

  def visible_services_count
    metric_groups.drop(1).sum { |m|
      if m.entity.respond_to? :services_count
        m.entity.services_count
      else
        1
      end
    }
  end

  def services_count
    if has_services?
      entity.services_count
    end
  end

  def collapsed?
    @selected_metric_sort_attribute != Metrics::Items::Name
  end

private

  attr_reader :client, :entity

  def data
    @data ||= client.metrics(entity, group_by: group_by)
  end

  def totals_metric_group_presenter
    @totals_metric_group_presenter ||= MetricGroupPresenter::Totals.new(data.totals, collapsed: collapsed?)
  end
end
