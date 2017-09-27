class CreateSellers < ActiveRecord::Migration[5.1]
  def change
    create_table :sellers do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.timestamps
    end
  end
end
