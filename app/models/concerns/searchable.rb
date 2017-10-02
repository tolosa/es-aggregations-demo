module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

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
