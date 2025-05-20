require_relative "20250520204826_association_between_users_and_roles"

class UsersRoles < ActiveRecord::Migration[8.0]
  def change
    revert AssociationBetweenUsersAndRoles

    create_table :roles_users, id: false do |t|
      t.belongs_to :user
      t.belongs_to :role
    end
  end
end
