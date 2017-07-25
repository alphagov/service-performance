class RenameHostnameToWebsite < ActiveRecord::Migration[5.0]
  def change
    rename_column :departments, :hostname, :website
    rename_column :delivery_organisations, :hostname, :website
  end
end
