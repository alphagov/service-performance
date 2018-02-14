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

  def metrics
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

  def missing_data_link
    Rails.application.routes.url_helpers.view_data_missing_url(only_path: true)
  end
end
