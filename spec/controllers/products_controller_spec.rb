require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
    describe "GET index" do
        context "when products exist" do
            it "show all products" do
                Product.create!(name: "Produit A", description: "Description produit A")
                Product.create!(name: "Produit B", description: "Description produit B")
                get :index
                expect(response).to have_http_status(:ok)
                expect(response.body).to include("Produit A")
                expect(response.body).to include("Produit B")
            end
        end
        context "when no products exist" do
            it "returns an empty list if no products exist" do
                get :index
                expect(response).to have_http_status(:ok)
                expect(response.body).to include('Aucun produit disponible')      
            end
        end
    end
end
