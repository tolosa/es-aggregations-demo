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
    def search(term, filters)
      __elasticsearch__.search search_query(term, filters)
    end

    private

    def search_query(term, filters)
      {
        query: {
          bool: {
            must: terms_query(term),
            filter: {
              bool: {
                must: filters_query(filters)
              }
            }
          }
        },
        aggregations: aggregations_query
      }
    end

    def terms_query(term)
      if term.blank?
        { match_all: {} }
      else
        {
          multi_match: {
            query: term,
            type: 'cross_fields',
            fields: '_all',
            operator: 'AND'
          }
        }
      end
    end

    def filters_query(filters)
      filters.map do |(filter, ids)|
        { terms: { "#{filter}.id" => ids } }
      end
    end

    def aggregations_query
      {}.tap do |query|
        AGGREGATIONS.each do |(name, args)|
          query.store name, {
            terms: { field: args[:field] }
          }
        end
      end
    end
  end
end
