class AddColsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :name, :string
    add_column :users, :last_name, :string
    add_column :users, :date_of_birth, :string
  end
end
