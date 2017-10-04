class AddDeliveryOrganisationIdToServices < ActiveRecord::Migration[5.1]
  def change
    add_column :services, :delivery_organisation_id, :integer
    add_foreign_key :services, :delivery_organisations
  end
end
