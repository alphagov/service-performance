class CreateDepartments < ActiveRecord::Migration[5.0]
  def change
    create_table :departments do |t|
      t.string	:natural_key
      t.string 	:natural_name
      t.string  :website

      t.timestamps
    end
  end
end
