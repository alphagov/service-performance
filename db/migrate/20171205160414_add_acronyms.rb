class AddAcronyms < ActiveRecord::Migration[5.1]
  def change
    add_column :departments, :acronym, :string, null: true
    add_column :delivery_organisations, :acronym, :string, null: true
  end
end
