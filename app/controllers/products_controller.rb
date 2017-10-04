class ProductsController < ApplicationController
  def index
    @search = params[:q]
    @filters = params[:filters] || {}
    results = Product.search(@search, @filters.to_hash)
    @products = results.page(params[:page]).records
    @aggregations = AggregationsCollection.build_from_results(results)
  end
end
