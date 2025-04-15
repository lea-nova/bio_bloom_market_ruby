class ProductsController < ApplicationController
  allow_unauthenticated_access only: %i[ index ]
  def index
    Rails.logger.info "Response Status Code: #{response.status}"
    @products = Product.all
  end

  private
  def product_param
    params.require(:product).permit(:name, :description)
  end
end

