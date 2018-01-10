class Government
  def name
    'UK government'
  end

  def departments
    Department.with_delivery_organisations
  end

  def delivery_organisations
    DeliveryOrganisation.with_services
  end

  def services
    Service.with_published_metrics
  end

  def metrics_search(search_term, group_by)
    if search_term
      services = case group_by
                 when Metrics::GroupBy::Department
                   p "Searching department for #{search_term}"
                   Department.search(search_term).map(&:services).flatten
                 when Metrics::GroupBy::DeliveryOrganisation
                   DeliveryOrganisation.search(search_term).map(&:services).flatten
                 when Metrics::GroupBy::Service
                   Service.search(search_term)
                 else
                   raise RuntimeError
                 end

      return MonthlyServiceMetrics.where(service_id: services.map(&:id))
    end

    MonthlyServiceMetrics.all
  end

  def departments_count
    Department.with_delivery_organisations.count
  end

  def delivery_organisations_count
    DeliveryOrganisation.with_services.count
  end

  def services_count
    Service.with_published_metrics.count
  end
end
