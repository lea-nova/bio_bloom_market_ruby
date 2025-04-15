require 'rails_helper'

RSpec.describe ProductsController, type: :request do
    describe "GET /products" do
        before do
            Product.create!(name:"Pomme", description:"Pomme gala")
            Product.create!(name:"Banane", description:"Banane")
        end
        it "send HTTP code 200" do
            get products_path
            expect(response).to have_http_status(:ok)
        end
        it "affiche le nom des produits dans la réponse" do
            get products_path
            expect(response.body).to include("Banane")
            expect(response.body).to include("Pomme")
        end
        it "affiche la description des produits dans la réponse" do
            get products_path
            expect(response.body).to include("Pomme gala")
            expect(response.body).to include("Banane")
        end
        it "affiche le nom de la page dans la réponse" do   
            get products_path
            expect(response.body).to include("Tous les produits")
        end
        it "affiche le template pour GET /products et tous les détails des produits" do
            get products_path
            ["Tous les produits", "Pomme", "Pomme gala", "Banane"].each do |content|
            expect(response.body).to include(content)
            end
        end
    end
    describe "GET /products special chars" do
        before do
            Product.create!(name: "Café", description: "Café avec du lait végétal de chataîgnes.")
        end
        it "product with special chars" do
            get products_path
            expect(response.body).to include("Café")
            expect(response.body).to include("Café avec du lait végétal de chataîgnes.")
        end
    end
    describe "GET /products empty" do 
        before do
            Product.delete_all
        end
        it "no products" do
            get products_path
            expect(response.body).to include("Aucun produit disponible")
        end
        before do
            Product.create(name: nil, description: "Produit lambda")
            Product.create(name:"Nom de produit", description: nil)
        end
    end
    describe "GET /products a lot of data" do
        before do
            100.times do |i|
            Product.create(name: "#{i}", description: "Description de #{i}")
            end
        end
        it "handling a lot of data" do
            get products_path
            expect(response.body).to include("Nom du produit : 99")
            expect(response.body.scan(/Nom du produit :/).size).to eq(100)
        end
    end
end

