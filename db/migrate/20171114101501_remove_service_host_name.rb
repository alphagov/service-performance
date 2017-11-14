class RemoveServiceHostName < ActiveRecord::Migration[5.1]
  def up
     remove_column :services, :hostname, :string
  end

  def down
    add_column :services, :hostname, :string
  end
end
