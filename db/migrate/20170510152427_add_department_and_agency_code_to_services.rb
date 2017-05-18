class AddDepartmentAndAgencyCodeToServices < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :department_code, :string, null: false
    add_column :services, :agency_code, :string

    add_foreign_key :services, :departments, column: :department_code, primary_key: :natural_key
    add_foreign_key :services, :agencies, column: :agency_code, primary_key: :natural_key
  end
end
