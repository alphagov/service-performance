class CreateDepartments < ActiveRecord::Migration[5.0]
  def change
    create_table :departments do |t|
      t.string :natural_key, null: false
      t.string :name, null: false
      t.string :hostname, null: false
      t.timestamps
    end

    add_index :departments, :natural_key, unique: true
  end
end
