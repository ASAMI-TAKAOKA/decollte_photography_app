class AddGlobalPositionToStores < ActiveRecord::Migration[8.0]
  def change
    add_column :stores, :global_position, :integer
  end
end
