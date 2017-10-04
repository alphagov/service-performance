class AddDepartmentIdToDeliveryOrganisations < ActiveRecord::Migration[5.1]
  def change
    add_column :delivery_organisations, :department_id, :integer
    add_foreign_key :delivery_organisations, :departments
  end
end
