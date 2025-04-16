class AddDefaultToAdminUsers < ActiveRecord::Migration[8.0]
  def change
    change_column_default :admin_users, :role, from: nil, to: 0
  end
end
