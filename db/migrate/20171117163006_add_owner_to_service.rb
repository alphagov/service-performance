class AddOwnerToService < ActiveRecord::Migration[5.1]
  def change
    add_column :services, :owner_id, :integer, null: true
    add_foreign_key :services, :users, column: :owner_id, primary_key: :id
  end
end
