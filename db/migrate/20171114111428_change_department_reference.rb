class ChangeDepartmentReference < ActiveRecord::Migration[5.1]
  def up
    add_column :delivery_organisations, :department_id, :integer, null: true
    add_foreign_key :delivery_organisations, :departments, column: :department_id, primary_key: :id

    sql = 'update delivery_organisations set department_id=(select id from departments D where D.natural_key="delivery_organisations".department_code);'
    ActiveRecord::Base.connection.execute(sql)

    remove_column :delivery_organisations, :department_code, :string, null: false
  end

  def down
    add_column :delivery_organisations, :department_code, :string, null: true

    execute 'update delivery_organisations set department_code=(select natural_key from departments D where D.id="delivery_organisations".department_id);'

    change_column :delivery_organisations, :department_code, :string, null: false
    remove_column :delivery_organisations, :department_id, :integer, null: true
  end
end
