class Government
  alias :read_attribute_for_serialization :send

  def id
    nil
  end

  def departments
    Department.all
  end

  def services
    Service.all
  end

  def departments_count
    Department.count
  end

  def delivery_organisations_count
    DeliveryOrganisation.count
  end

  def services_count
    Service.count
  end
end