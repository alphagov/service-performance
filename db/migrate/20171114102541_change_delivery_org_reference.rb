class ChangeDeliveryOrgReference < ActiveRecord::Migration[5.1]
  def change
    add_column :services, :delivery_organisation_id, :integer, null: true
    add_foreign_key :services, :delivery_organisations, column: :delivery_organisation_id, primary_key: :id

    sql = 'update services set delivery_organisation_id=(select id from delivery_organisations D where D.natural_key="services".delivery_organisation_code);'
    ActiveRecord::Base.connection.execute(sql)

    change_column :services, :delivery_organisation_id, :integer, null: false
    remove_column :services, :delivery_organisation_code, :string, null: false
  end
end

