class ProductsController < ApplicationController
  def index
    @search = params[:q]
    @products = Product.search(@search.presence || '*').page(params[:page]).records
  end
end
