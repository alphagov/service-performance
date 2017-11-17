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

  action_item :view, only: :index do
    link_to 'Synchronise Departments', sync_admin_departments_path, method: :post
  end

  collection_action :sync, method: :post do
    DeliveryOrganisationsImporter.new.import

    mapping_file = File.read(Rails.root.join("app", "assets", "config", "department_mapping.csv"))
    DepartmentsImporter.new.import(mapping_file)

    redirect_to collection_path, notice: "Departments imported successfully!"
  end
end
