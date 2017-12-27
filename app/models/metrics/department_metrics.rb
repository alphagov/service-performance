class DepartmentMetrics < Metrics
  def self.valid_group_bys
    [GroupBy::Department, GroupBy::DeliveryOrganisation, GroupBy::Service]
  end

  def entities
    case group_by
    when GroupBy::Department
      [root]
    when GroupBy::DeliveryOrganisation
      return DeliveryOrganisation.search(@search_term).where(department: root) if @search_term
      root.delivery_organisations
    when GroupBy::Service
      if @search_term
        orgs = DeliveryOrganisation.where(department: root).pluck(:id)
        return Service.search(@search_term).where(delivery_organisation: orgs)
      end
      root.services
    end
  end
end
