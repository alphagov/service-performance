class AddUniqueIndexToServicesNaturalKey < ActiveRecord::Migration[5.0]
  def change
    add_index :services, :natural_key, unique: true
  end
end
