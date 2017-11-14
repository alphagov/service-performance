ActiveAdmin.register DeliveryOrganisation do
  includes :department

  permit_params :natural_key, :name, :website, :department_id

  index do
    column :natural_key
    column :name
    column :department
    actions
  end
end
