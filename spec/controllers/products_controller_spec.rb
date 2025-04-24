require 'rails_helper'

RSpec.describe ProductsController, type: :request do
    describe "GET /products" do
        before do
            Product.create!(name: "Pomme", description: "Pomme gala")
            Product.create!(name: "Banane", description: "Banane")
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
    end
    describe "GET /products empty" do
    it "no products" do
        Product.delete_all
        get products_path
        expect(response.body).to include("Aucun produit disponible")
    end
    end

    describe "GET /products/new" do
        let(:user) do
            User.create!(
              email_address: "test@example.com",
              password: "azerty",
              name: "test",
              last_name: "name"
            )
          end
          context "when user is authenticated" do
            before do
              # Simulate user authentication by setting the session cookie
              post session_path params: { email_address: user.email_address, password: user.password }
            end
            it "displays the form" do
              get new_product_path
              expect(response).to have_http_status(:ok)
              expect(response.body).to include('<form')
              expect(response.body).to include('name="product[name]"')
              expect(response.body).to include('name="product[description]"')
            end
          end
          context "when user is not authenticated" do
            it "does not display the form and redirects to login" do
              get new_product_path
              expect(response).to have_http_status(:found) # Assuming it redirects to login
              expect(response).to redirect_to(new_session_path)
              expect(response.body).not_to include('<form')
            end
          end
      end
      describe "POST /products" do
        let(:user) do
          User.create!(
            email_address: "test@example.com",
            password: "azerty",
            name: "test",
            last_name: "name"
          )
        end
        before do
          # Simulate user authentication by setting the session cookie
          post session_path params: { email_address: user.email_address, password: user.password }
        end
        let (:valid_attributes) { { name: "Pomme", description: "Pomme gala" } }
        let (:invalid_attributes) { { name: "", description: "" } }
          it "create one product" do
            # get products_new_path
            product = Product.create(valid_attributes)
            post products_path, params: { product: valid_attributes }
            # 1. Vérifier que l'objet est conforme aux validations présentes dans le model.
            expect(product).to be_valid
            # 2. Vérifier que l'objet est bien save dans la base.
            expect(product).to be_persisted
            # 3. Vérifier que la réponse redirige vers la bonne page après la création.
            expect(response).to have_http_status(:found)
            # EN PLUS : tester le changement du nombre de rows en base de données.
            expect { post products_path, params: { product: valid_attributes } }.to change(Product, :count).by(1)
          end
          it "does not create one product" do
            product = Product.create(invalid_attributes)
            expect(product).not_to be_valid
            expect(product.errors[:name]).to include("Le nom du produit ne peut pas être vide.")
            expect(product.errors[:description]).to include("La description du produit ne peut pas être vide.")
          end
    end
    describe "GET /products/:id " do
      let(:product) { Product.create!(name: "Pomme", description: "Description pomme") }
      it "product exists" do
        get products_path(product)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Pomme")
        expect(response.body).to include("Description pomme")
      end
      it "product doesn't exist" do
        # Simule un ID inexistant qui provoque une exception
        allow(Product).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
        get products_path(id: 999)
        expect(response).to have_http_status(:ok)
        expect(response).not_to include('Pomme')
        expect(response).not_to include('Description pomme')
      end
    end
    describe "GET /products/:id/edit edit one product" do
      let(:user) do
        User.create!(
          email_address: "test@example.com",
          password: "azerty",
          name: "test",
          last_name: "name"
        )
      end
      let(:product) { Product.create!(name: "Pomme", description: "Description pomme") }
      before do
        # Simulate user authentication by setting the session cookie
        post session_path params: { email_address: user.email_address, password: user.password }
      end
      it "display the form" do
        get edit_product_path(:id)
        expect(response).to have_http_status(:found)
      end
      it "does not display the form and redirects to login" do
        get edit_product_path(:id)
        expect(response).to have_http_status(:found) # Assuming it redirects to login
        expect(response).to redirect_to(products_path)
        expect(response.body).not_to include('<form')
      end
    end
    describe "PATCH /products/:id" do
      it "user not auth" do
        get product_path(:id)
        expect(response).to have_http_status(:found) # Assuming it redirects to login
        # expect(response).to redirect_to(new_session_path)
        # expect(response.body).not_to include('<form')
      end
      let(:user) do
        User.create!(
          email_address: "test@example.com",
          password: "azerty",
          name: "test",
          last_name: "name"
        )
      end
      before do
        # Simulate user authentication by setting the session cookie
        post session_path params: { email_address: user.email_address, password: user.password }
      end
        it "update one product" do
          product = Product.create!(name: "Pomme", description: "Description pomme")
          patch product_path(:id), params: { product: { name: "Pomme verte", description: "Description de la pomme verte" } }
          expect(response).to have_http_status(:found)
        end
    end
  end
