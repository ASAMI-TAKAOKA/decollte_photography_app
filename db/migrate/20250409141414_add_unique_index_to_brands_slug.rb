class AddUniqueIndexToBrandsSlug < ActiveRecord::Migration[8.0]
  def change
    remove_index :brands, :slug

    add_index :brands, :slug, unique: true
  end
end
