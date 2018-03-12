module LinksHelper
  def current_group(group, metric_group, anchor)
    if group == Department
      view_data_department_path(metric_group.entity.natural_key, anchor: anchor)
    elsif group == DeliveryOrganisation
      view_data_delivery_organisation_path(metric_group.entity.natural_key, anchor: anchor)
    elsif group == Service
      view_data_service_path(metric_group.entity.natural_key, anchor: anchor)
    else
      view_data_path(anchor: anchor)
    end
  end
end
