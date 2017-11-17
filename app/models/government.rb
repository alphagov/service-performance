class Government
  alias :read_attribute_for_serialization :send

  def departments
    orgs = DeliveryOrganisation.joins(:services).distinct.pluck(:department_id)
    Department.find(orgs)
  end

  def delivery_organisations
    DeliveryOrganisation.joins(:services).distinct.all
  end

  def services
    Service.all
  end

  def metrics
    MonthlyServiceMetrics.all
  end

  def departments_count
    orgs = DeliveryOrganisation.joins(:services).distinct.pluck(:department_id)
    Department.find(orgs).count
  end

  def delivery_organisations_count
    DeliveryOrganisation.joins(:services).distinct.count
  end

  def services_count
    Service.count
  end
end
