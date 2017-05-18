class CreateAgencies < ActiveRecord::Migration[5.0]
  def change
    create_table :agencies do |t|
      t.string :natural_key, null: false
      t.string :name, null: false
      t.string :hostname, null: false
      t.string :department_code, null: false
      t.timestamps
    end

    add_index :agencies, :natural_key, unique: true
    add_foreign_key :agencies, :departments, column: :department_code, primary_key: :natural_key
  end
end
