class CreateStores < ActiveRecord::Migration[8.0]
  def change
    create_table :stores do |t|
      t.string :name
      t.references :brand, null: false, foreign_key: true
      t.string :address
      t.string :phone_number
      t.integer :position

      t.timestamps
    end
  end
end
