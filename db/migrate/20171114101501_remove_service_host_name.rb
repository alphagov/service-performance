class RemoveServiceHostName < ActiveRecord::Migration[5.1]
  def change
     remove_column :services, :hostname, :string
  end
end
