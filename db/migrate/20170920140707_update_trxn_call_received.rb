class UpdateTrxnCallReceived < ActiveRecord::Migration[5.0]
  def change
    CallsReceivedMetric.where(item: 'total').each do |cr|
      current = CallsReceivedMetric.where(
        item: 'perform-transaction',
        starts_on: cr.starts_on,
        ends_on: cr.ends_on
      ).first
      next if current

      phone_trxn = TransactionsReceivedMetric.where(
        channel: 'phone',
        service_code: cr.service_code,
        starts_on: cr.starts_on,
        ends_on: cr.ends_on
      ).first
      next if !phone_trxn

      new_cr = cr.dup
      new_cr.item = 'perform-transaction'
      new_cr.quantity = phone_trxn.quantity
      new_cr.save!

    end
  end
end
