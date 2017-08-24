class UnflattenCallsRx < ActiveRecord::Migration[5.0]
  def change
    # Copy table
    sql = "select * into tmp_calls_rx from calls_received_metrics;"
    ActiveRecord::Base.connection.execute(sql)

    remove_column :calls_received_metrics, :quantity_of_get_information
    remove_column :calls_received_metrics, :quantity_of_chase_progress
    remove_column :calls_received_metrics, :quantity_of_challenge_a_decision
    remove_column :calls_received_metrics, :quantity_of_other

    change_column :calls_received_metrics, :quantity, :integer, null: true

    # Add new columns
    add_column :calls_received_metrics, :item, :string, null: false

    # Copy across data from tmp_calls_rx
    CallsReceivedMetric.delete_all
    sql = 'select * from tmp_calls_rx;'
    records_array = ActiveRecord::Base.connection.execute(sql)
    records_array.each{ |row|

        quantity_of_other = row.delete('quantity_of_other')
        quantity_of_get_information = row.delete('quantity_of_get_information')
        quantity_of_chase_progress = row.delete('quantity_of_chase_progress')
        quantity_of_challenge_a_decision = row.delete('quantity_of_challenge_a_decision')
        quantity_total = row.delete('quantity')

        row.delete('id')

        t_other = CallsReceivedMetric.new(row)
        t_other.item = 'other'
        t_other.quantity = quantity_of_other
        t_other.save!

        t_get = CallsReceivedMetric.new(row)
        t_get.item = 'get-information'
        t_get.quantity = quantity_of_get_information
        t_get.save!

        t_chase = CallsReceivedMetric.new(row)
        t_chase.item = 'chase-progress'
        t_chase.quantity = quantity_of_chase_progress
        t_chase.save!

        t_challenge = CallsReceivedMetric.new(row)
        t_challenge.item = 'challenge-a-decision'
        t_challenge.quantity = quantity_of_challenge_a_decision
        t_challenge.save!

        t_total = CallsReceivedMetric.new(row)
        t_total.item = 'total'
        t_total.quantity = quantity_total
        t_total.save!
    }

    drop_table :tmp_calls_rx
  end

end
