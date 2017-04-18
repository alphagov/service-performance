class CreateServices < ActiveRecord::Migration[5.0]
  def change
    create_table :services do |t|
      t.integer	:natural_key
      t.string 	:natural_name
      t.string 	:hostname

      t.timestamps
    end
  end
end
