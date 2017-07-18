class AllowQuantityWithIntendedOutcomeToBeNull < ActiveRecord::Migration[5.0]
  def change
    change_column_null :transactions_with_outcome_metrics, :quantity_with_intended_outcome, true
  end
end
