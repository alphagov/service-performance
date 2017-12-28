class RemoveUnusedContextFields < ActiveRecord::Migration[5.1]
  def change
    remove_column :services, :frequency_used, :text
    remove_column :services, :duration_until_outcome, :text
  end
end
