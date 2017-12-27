class GovernmentMetrics < Metrics
  def self.valid_group_bys
    [GroupBy::Government, GroupBy::Department, GroupBy::DeliveryOrganisation, GroupBy::Service]
  end

  def entities
    case group_by
    when GroupBy::Government
      [root]
    when GroupBy::Department
      return Department.search(@search_term) if @search_term
      root.departments
    when GroupBy::DeliveryOrganisation
      return DeliveryOrganisation.search(@search_term) if @search_term
      root.delivery_organisations
    when GroupBy::Service
      return Service.search(@search_term) if @search_term
      root.services
    end
  end
end
