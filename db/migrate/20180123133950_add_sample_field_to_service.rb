class AddSampleFieldToService < ActiveRecord::Migration[5.1]
  def change
    add_column :services, :sampled_calls, :boolean, null: false, default: false    
  end
end
