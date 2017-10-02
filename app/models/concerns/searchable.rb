module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    def self.search(query)
      __elasticsearch__.search(query.blank? ? '*' : {
        query: {
          multi_match: {
            query: query,
            type: 'cross_fields',
            fields: '_all',
            operator: 'AND'
          }
        }
      })
    end

    def as_indexed_json(options = {})
      self.as_json(
        only: [:name, :price],
        include: {
          categories: { only: :name },
          manofacturer: { only: :name },
          seller: { only: :full_name , methods: [:full_name] }
        })
    end
  end
end
