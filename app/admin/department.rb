ActiveAdmin.register Department do
  permit_params :natural_key, :name, :website

  index do
    column :natural_key
    column :name
    actions
  end
end
