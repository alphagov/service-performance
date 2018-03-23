class AddEmailMetric < ActiveRecord::Migration[5.1]
  def change
    add_column :monthly_service_metrics, :email_transactions, :integer
    add_column :services, :email_transactions_applicable, :boolean, default: false
  end
end
