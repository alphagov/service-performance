class CreateServices < ActiveRecord::Migration[5.1]
  def change
    create_table :services do |t|
      t.string :name, null: false
      t.text :purpose
      t.text :how_it_works
      t.text :typical_users
      t.text :frequency_used
      t.text :duration_until_outcome
      t.string :start_page_url
      t.string :paper_form_url
      t.timestamps
    end
  end
end
