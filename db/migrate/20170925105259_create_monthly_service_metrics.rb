class CreateMonthlyServiceMetrics < ActiveRecord::Migration[5.1]
  def change
    create_table :monthly_service_metrics do |t|
      t.references :service, null: false
      t.date :month, null: false
      t.integer :online_transactions
      t.integer :phone_transactions
      t.integer :paper_transactions
      t.integer :face_to_face_transactions
      t.integer :other_transactions
      t.integer :transactions_with_outcome
      t.integer :transactions_with_intended_outcome
      t.integer :calls_received
      t.integer :calls_received_get_information
      t.integer :calls_received_chase_progress
      t.integer :calls_received_challenge_decision
      t.integer :calls_received_other
    end

    add_foreign_key :monthly_service_metrics, :services
  end
end
