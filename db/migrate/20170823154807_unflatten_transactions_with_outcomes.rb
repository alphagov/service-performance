class UnflattenTransactionsWithOutcomes < ActiveRecord::Migration[5.0]
  def change
    # Copy table
    sql = "select * into tmp_two from transactions_with_outcome_metrics;"
    ActiveRecord::Base.connection.execute(sql)

    # Remove unused columns
    remove_column :transactions_with_outcome_metrics, :quantity_with_any_outcome
    remove_column :transactions_with_outcome_metrics, :quantity_with_intended_outcome

    # Add new columns
    add_column :transactions_with_outcome_metrics, :outcome, :string, null: true
    add_column :transactions_with_outcome_metrics, :quantity, :integer

    # Copy across data from tmp_two
    TransactionsWithOutcomeMetric.delete_all
    sql = "select * from tmp_two;"
    records_array = ActiveRecord::Base.connection.execute(sql)
    records_array.each{ |row|

        quantity_any = row.delete("quantity_with_any_outcome")
        quantity_intended = row.delete("quantity_with_intended_outcome")
        row.delete("id")

        t_any = TransactionsWithOutcomeMetric.new(row)
        t_any.outcome = "any"
        t_any.quantity = quantity_any
        t_any.save!

        t_intended = TransactionsWithOutcomeMetric.new(row)
        t_intended.outcome = "intended"
        t_intended.quantity = quantity_intended
        t_intended.save!
    }

    drop_table :tmp_two
    change_column :transactions_with_outcome_metrics, :outcome, :string, null: false
  end
end
