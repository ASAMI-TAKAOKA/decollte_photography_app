class AddUniqueIndexToStoresName < ActiveRecord::Migration[8.0]
  def change
    add_index :stores, :name, unique: true
  end
end
