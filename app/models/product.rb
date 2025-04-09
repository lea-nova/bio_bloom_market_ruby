class Product < ApplicationRecord
    validates :name, presence: { message: "Le nom du produit ne peut pas être vide." }
    validates :description, presence: { message: "La description du produit ne peut pas être vide." }
end