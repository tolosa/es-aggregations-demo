class CreateJoinTableProductCategory < ActiveRecord::Migration[5.1]
  def change
    create_join_table :products, :categories do |t|
      t.index [:product_id, :category_id]
    end
  end
end
