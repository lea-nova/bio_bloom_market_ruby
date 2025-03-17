class AddColsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :name, :string
    add_column :users, :lastName, :string
    add_column :users, :dateOfBirth, :string
  end
end
