class MissingDataCalculator
  attr_reader :missing_data

  def initialize(entity, time_period)
    @time_period = time_period
    @missing_data = []

    # For each service we need to use the metricspresenter to work out if it is complete
    # or not. If it is complete we will skip it.
    entity.services.with_published_metrics.order("name").each { |s| process_service(s) }
  end

private

  def process_service(svc)
    # Create a new metrics presenter, and then pull out the individual metric groups, and the list
    # of monthly metrics for this service.
    presenter = MetricsPresenter.new(svc, group_by: Metrics::GroupBy::Service, time_period: @time_period)
    groups = presenter.metric_groups
    months = presenter.published_monthly_service_metrics

    # Calculate the overall completeness for this these groups
    completeness = groups.map { |metric_group|
      MetricGroupPresenter.new(metric_group, collapsed: false).metrics.flat_map { |metric|
        if metric.nil?
          Completeness.new(actual: 0, expected: 0)
        else
          metric.completeness.values
        end
      }.reduce(:+)
    }.sum

    # If this service is actually complete, then it shouldn't be shown on this page and
    # so we can safely return.  Otherwise we'll calculate the top level completeness
    # score before processing the individual metrics.
    return if completeness.actual == completeness.expected
    service_percentage = (completeness.actual.to_f / completeness.expected.to_f) * 100
    service_percentage = 0 if service_percentage.nan?


    missing = MissingData.new(svc.name, service_percentage.to_i)
    groups[0].metrics.each { |metric_group|
      process_group(metric_group, months, missing)
    }
    @missing_data << missing
  end

  def process_group(metrics, months, missing)
    metrics.instance_variables.each { |var|
      var_string = var.to_s.sub("@", "")
      if var_string.ends_with?("completeness")
        completeness = metrics.send(var_string.to_sym)
        var_string = var_string.sub("_completeness", "")
        if completeness.actual != completeness.expected
          label = I18n.translate(var_string, scope: ["helpers", "missing", metrics.class])

          metric_name = metrics.name_to_db_name(:"#{var_string}".to_sym)
          months_missing = months_string(months, metric_name)
          missing.add_metrics(label, completeness.as_percentage, months_missing)
        end
      end
    }
  end

  def months_string(months, metric_name)
    start_date = @time_period.starts_on
    end_date = @time_period.ends_on

    date_list = months.map { |month|
      val = month.send(metric_name)
      if val.nil? # Not provided
        nil
      else
        month.month.date
      end
    }.compact.sort

    # date_list is a list of dates where we do have data, and we want to know what dates
    # we don't have data
    dummy(start_date, end_date, date_list)
  end

  def dummy(_start, _end, _list); end
end
