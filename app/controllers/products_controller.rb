class ProductsController < ApplicationController
  def index
    @search = params[:q]
    results = Product.search(@search)
    @products = results.page(params[:page]).records
    @aggregations = AggregationsCollection.build_from_results(results)
  end
end
