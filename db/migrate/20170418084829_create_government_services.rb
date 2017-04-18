class CreateGovernmentServices < ActiveRecord::Migration[5.0]
  def change
    create_table :government_services do |t|
      t.integer :natural_pk
      t.string :natural_name
      t.string :hostname

      t.timestamps
    end
  end
end
