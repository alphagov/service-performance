class MakeTxRecvValueNullable < ActiveRecord::Migration[5.0]
  def change
    change_column :transactions_received_metrics, :quantity, :integer, null: true
  end
end
