class ChangeDeliveryOrgReference < ActiveRecord::Migration[5.1]
  def up
    add_column :services, :delivery_organisation_id, :integer, null: true
    add_foreign_key :services, :delivery_organisations, column: :delivery_organisation_id, primary_key: :id

    execute 'update services set delivery_organisation_id=(select id from delivery_organisations D where D.natural_key="services".delivery_organisation_code);'

    change_column :services, :delivery_organisation_id, :integer, null: false
    remove_column :services, :delivery_organisation_code, :string, null: false
  end

  def down
    add_column :services, :delivery_organisation_code, :string, null: true
    add_foreign_key :services, :delivery_organisations, column: :delivery_organisation_code, primary_key: :natural_key

    execute 'update services set delivery_organisation_code=(select natural_key from delivery_organisations D where D.id="services".delivery_organisation_id);'

    change_column :services, :delivery_organisation_code, :string, null: false
    remove_column :services, :delivery_organisation_id, :integer, null: true
  end
end

