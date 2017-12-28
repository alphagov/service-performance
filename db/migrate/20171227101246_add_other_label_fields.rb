class AddOtherLabelFields < ActiveRecord::Migration[5.1]
  def change
    add_column :services, :calls_other_name, :text
    add_column :services, :other_name, :text
  end
end
