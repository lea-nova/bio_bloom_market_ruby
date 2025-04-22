class ProductsController < ApplicationController
  allow_unauthenticated_access only: %i[ index ]
  def index
    Rails.logger.info "Response Status Code: #{response.status}"
    @products = Product.all
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

  private
  def product_params
    params.expect(product: [:name, :description])
    # params.require(:product).permit(:name, :description)
  end
end
