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
      flash[:alert]= "Produit introuvable"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product = Product.find(params[:id])
    if @product.destroy
      flash[:notice] = "Le produit a été supprimé avec succès."
      redirect_to products_path
    else
      flash[:alert] = "La suppression du produit a échoué."
      render :show, status: :unprocessable_entity
    end
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
