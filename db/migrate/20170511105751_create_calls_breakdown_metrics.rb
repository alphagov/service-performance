class CreateCallsBreakdownMetrics < ActiveRecord::Migration[5.0]
  def change
    create_table :calls_breakdown_metrics do |t|
      t.string :department_code, null: false
      t.string :agency_code
      t.string :service_code, null: false

      t.date :starts_on, null: false
      t.date :ends_on, null: false

      t.bigint :quantity, null: false
      t.boolean :sampled, null: false
      t.integer :sample_size
      t.string :reason, null: false

      t.timestamps
    end

    add_foreign_key :calls_breakdown_metrics, :departments, column: :department_code, primary_key: :natural_key
    add_foreign_key :calls_breakdown_metrics, :agencies, column: :agency_code, primary_key: :natural_key
    add_foreign_key :calls_breakdown_metrics, :services, column: :service_code, primary_key: :natural_key
  end
end
