class ChangeServicesNameAndHostnameToBeNonNull < ActiveRecord::Migration[5.0]
  def change
    change_column :services, :name, :string, null: false
    change_column :services, :hostname, :string, null: false
  end
end
