class AddIndexToRoles < ActiveRecord::Migration[8.0]
  def change
    add_index :roles, :name
  end
end
