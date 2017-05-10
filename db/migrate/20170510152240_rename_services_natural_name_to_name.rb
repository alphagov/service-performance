class RenameServicesNaturalNameToName < ActiveRecord::Migration[5.0]
  def change
    rename_column :services, :natural_name, :name
  end
end
