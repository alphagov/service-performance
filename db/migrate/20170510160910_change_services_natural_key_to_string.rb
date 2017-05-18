class ChangeServicesNaturalKeyToString < ActiveRecord::Migration[5.0]
  def change
    change_column :services, :natural_key, :string, null: false
  end
end
