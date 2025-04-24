class ProductsController < ApplicationController
  allow_unauthenticated_access only: %i[ index ]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  def index
    Rails.logger.info "Response Status Code: #{response.status}"
    @products = Product.all
  end
  def show
    @product = Product.find(params[:id])
  end
  def new
    @product = Product.new
  end
  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path, notice: "Product was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end
  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to @product, notice: "Produit mis à jour"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to products_path, notice: "Produit supprimé avec succès."
  end

  private
  def record_not_found
    flash[:alert] = "Produit introuvable"
    redirect_to products_path, notice: "Produit introuvable"
  end

  private
  def product_params
    params.expect(product: [ :name, :description ])
  end
end
