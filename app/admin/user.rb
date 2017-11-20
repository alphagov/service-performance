ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :email
      row :current_sign_in_at
      row :sign_in_count
      row :created_at
    end

    panel "Services" do
      user.services.each do |svc|
        li link_to(svc.name, admin_service_path(svc))
      end
    end
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    # Currently we don't expect users to log in, we are just using their email
    # address and so we set their password to something we don't know.
    passwd = Devise.friendly_token.first(32)

    f.inputs do
      f.input :email
      f.input :password, input_html: { value: f.object.password ||= passwd }
      f.input :password_confirmation, input_html: { value: f.object.password_confirmation ||= passwd }
    end
    f.actions
  end
end
