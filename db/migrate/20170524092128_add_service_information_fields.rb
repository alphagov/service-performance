class AddServiceInformationFields < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :purpose, :text
    add_column :services, :how_it_works, :text
    add_column :services, :typical_users, :text
    add_column :services, :frequency_used, :text
    add_column :services, :duration_until_outcome, :text
    add_column :services, :start_page_url, :string
    add_column :services, :paper_form_url, :string
  end
end
