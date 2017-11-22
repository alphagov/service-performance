ActiveAdmin.register DeliveryOrganisation do
  includes :department

  controller do
    defaults finder: :find_by_natural_key
  end

  permit_params :natural_key, :name, :website, :department_id

  index do
    column :natural_key
    column :name
    column :department
    actions
  end

  show do
    attributes_table do
      row :name
      row :department
      row :website
      row :natural_key
    end

    panel "Services" do
      delivery_organisation.services.each do |svc|
        li link_to(svc.name, admin_service_path(svc))
      end
    end
  end
end
