class AddUniqueIndexToRolesUsers < ActiveRecord::Migration[8.0]
  def change
    add_index :roles_users, [:role_id, :user_id], unique: true
  end
end
