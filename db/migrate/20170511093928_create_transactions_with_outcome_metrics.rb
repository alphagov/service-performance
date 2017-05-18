class CreateTransactionsWithOutcomeMetrics < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions_with_outcome_metrics do |t|
      t.string :department_code, null: false
      t.string :agency_code
      t.string :service_code, null: false

      t.date :starts_on, null: false
      t.date :ends_on, null: false

      t.bigint :quantity_with_any_outcome, null: false
      t.bigint :quantity_with_intended_outcome, null: false

      t.timestamps
    end

    add_foreign_key :transactions_with_outcome_metrics, :departments, column: :department_code, primary_key: :natural_key
    add_foreign_key :transactions_with_outcome_metrics, :agencies, column: :agency_code, primary_key: :natural_key
    add_foreign_key :transactions_with_outcome_metrics, :services, column: :service_code, primary_key: :natural_key
  end
end
