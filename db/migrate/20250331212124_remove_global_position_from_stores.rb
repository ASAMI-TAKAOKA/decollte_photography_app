class RemoveGlobalPositionFromStores < ActiveRecord::Migration[8.0]
  def change
    remove_column :stores, :global_position, :integer
  end
end
