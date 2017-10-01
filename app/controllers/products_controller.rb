class ProductsController < ApplicationController
  def index
    @products = Product.limit(20)
  end
end
