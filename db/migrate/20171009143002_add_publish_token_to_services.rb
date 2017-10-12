class AddPublishTokenToServices < ActiveRecord::Migration[5.1]
  def change
    add_column :services, :publish_token, :string
    add_index :services, :publish_token, unique: true
  end
end
