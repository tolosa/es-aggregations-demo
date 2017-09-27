class AddManofacturerRefToProducts < ActiveRecord::Migration[5.1]
  def change
    add_reference :products, :manofacturer, foreign_key: true, null: false
  end
end
