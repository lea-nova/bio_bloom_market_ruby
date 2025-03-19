class RemoveCols < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :lastName
    remove_column :users, :dateOfBirth
  end
end
