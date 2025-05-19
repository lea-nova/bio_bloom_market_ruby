require 'rails_helper'

RSpec.describe ProductsController, type: :request do
  let(:user) do
            User.create!(
              email_address: "test@example.com",
              password: "azerty",
              name: "test",
              last_name: "name"
            )
          end
    before(:all) do
      Product.create!(name: "Pomme", description: "Pomme gala")
      Product.create!(name: "Banane", description: "Banane")
    end
  before do
          post session_path params: { email_address: user.email_address, password: user.password }  if user.present?
  end
    describe "GET /products" do
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
      before { Product.delete_all }
      it "no products" do
          get products_path
          expect(response.body).to include("Aucun produit disponible")
      end
    end

    describe "GET /products/new" do
          subject(:get_new_product) do
            get new_product_path
          end
          it "displays the form" do
            get_new_product
            expect(response).to have_http_status(:ok)
            expect(response.body).to include('<form')
            expect(response.body).to include('name="product[name]"')
            expect(response.body).to include('name="product[description]"')
          end
          context "when user is not authenticated" do
            let(:user) { nil }
            it "does not display the form and redirects to login" do
              get_new_product
              expect(response).to have_http_status(:found)
              expect(response).to redirect_to(new_session_path)
            end
          end
      end
      describe "POST /products" do
        let(:valid_attributes) do
          {
            name: "Pomme",
            description: "Pomme gala"
          }
        end
        let(:invalid_attributes) do
          {
            name: "",
            description: ""
          }
        end
        let(:attributes) { valid_attributes }
        let(:params) do
          { product: attributes }
        end
        subject(:post_product) do
          post products_path, params: params
        end

          it "create one product" do
            expect { post_product }.to change { Product.count }.by(1)
            expect(response).to have_http_status(302)
            expect(response).to redirect_to(products_path)
          end
          context "when attributes are invalid" do
            let(:attributes) { invalid_attributes }
            it "does not create one product" do
              expect { post_product }.not_to change { Product.count }
              expect(response).to have_http_status(:unprocessable_entity)
            end
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
      context "when the action fails" do
        it "product doesn't exist" do
        get product_path(id: 999)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(products_path)
        follow_redirect!
        expect(response.body).to include("Produit introuvable")
        end
      end
    end
    describe "UPDATE /products/:id/edit edit one product" do
      let(:product) { Product.create!(name: "Pomme", description: "Description pomme") }
      it "display the form" do
        get edit_product_path(product)
        expect(response).to have_http_status(:ok)
      end
      context "when the user is not authenticated" do
        let(:user) { nil }
        it "does not display the form and redirects to login" do
          get edit_product_path(product)
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(new_session_path)
        end
      end
    end
    describe "PATCH /products/:id" do
      let (:product) { Product.create!(name: "Pomme", description: "Description pomme") }
      let (:valid_params) { { product: { name: "Pomme verte", description: "Description de la pomme verte" } } }
        it "update one product" do
          patch product_path(product), params:  valid_params
          expect(response).to have_http_status(:found)
        end
        context "when user not auth" do
          let(:user) { nil }
          it "does not display the form, redirect to login page" do
            get product_path(product)
            expect(response).to have_http_status(:found)
            expect(response).to redirect_to(new_session_path)
          end
        end
        context "when the product update fails" do
          let(:invalid_params) { { product: { name: "", description: "" } } }
        it "does not update one product" do
            patch product_path(product), params: invalid_params
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
    end
    describe "DELETE /products/:id" do
      let(:product) do
        Product.create!(name: "Pomme", description: "Description pomme")
      end
      subject(:delete_product) do
        delete product_path(product)
      end
      it "delete one product" do
        delete_product
        expect(response).to have_http_status(:found)
        expect(Product.exists?(product.id)).to be_falsey
        expect(response).to redirect_to(products_path)
      end

      context "when destroy fails" do
        before do
          # mock
          allow_any_instance_of(Product).to receive(:destroy).and_return(false)
        end
        it "does not delete one product" do
          delete_product
          expect(response).to have_http_status(:unprocessable_entity)
          expect(Product.exists?(product.id)).to be_truthy
          expect(flash[:alert]).to eq("La suppression du produit a échoué.")
        end
      end
  end
end
