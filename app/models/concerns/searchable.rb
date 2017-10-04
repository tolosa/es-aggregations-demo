module Searchable
  extend ActiveSupport::Concern

  AGGREGATIONS = {
    categories: { field: 'categories.id', title: :name, model: Category },
    manofacturer: { field: 'manofacturer.id', title: :name, model: Manofacturer },
    seller: { field: 'seller.id', title: :full_name, model: Seller }
  }.with_indifferent_access.freeze

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    def as_indexed_json(options = {})
      self.as_json(
        only: %i[name price],
        include: {
          categories: { only: %i[id name] },
          manofacturer: { only: %i[id name] },
          seller: { only: %i[id full_name] , methods: :full_name }
        })
    end
  end

  class_methods do
    def search(term)
      __elasticsearch__.search search_query(term).merge(aggregation_query)
    end

    private

    def search_query(term)
      if term.blank?
        { size: 0 }
      else
        {
          query: {
            multi_match: {
              query: term,
              type: 'cross_fields',
              fields: '_all',
              operator: 'AND'
            }
          }
        }
      end
    end

    def aggregation_query
      query = {}
      AGGREGATIONS.each do |(name, args)|
        query[name] = {
          terms: { field: args[:field] }
        }
      end
      { aggregations: query }
    end
  end
end
