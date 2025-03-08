class CreateAdminUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :admin_users do |t|
      t.string :username
      t.string :password_digest
      t.integer :role

      t.timestamps
    end
  end
end
