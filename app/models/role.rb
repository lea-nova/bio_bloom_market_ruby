class Role < ApplicationRecord
    validates :name, presence: { message: "Le nom du rôle ne peut être vide." }, uniqueness: { message: "Le nom de rôle existe déjà." }
  has_and_belongs_to_many :users
end
