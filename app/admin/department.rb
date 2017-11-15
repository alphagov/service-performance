ActiveAdmin.register Department do
  permit_params :natural_key, :name, :website

  index do
    column :natural_key
    column :name
    actions
  end

  show do
    attributes_table do
      row :name
      row :website
      row :natural_key
    end
    panel "Delivery organisations" do
      department.delivery_organisations.each do |org|
        li link_to(org.name, admin_delivery_organisation_path(org))
      end
    end
  end
end
