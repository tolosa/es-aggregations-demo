COUNTS = { products: 500, categories: 10, sellers: 10, manofacturers: 5 }.freeze

Faker::Config.random = Random.new(666)

ActiveRecord::Base.transaction do
  # clears all
  Product.destroy_all
  [Category, Manofacturer, Seller].each(&:delete_all)

  # create categories
  categories = []
  COUNTS[:categories].times do
    categories << Category.create!(name: Faker::Commerce.unique.department(1))
  end

  # create sellers
  sellers = []
  COUNTS[:sellers].times do
    sellers << Seller.create!(first_name: Faker::Name.unique.first_name,
      last_name: Faker::Name.unique.last_name)
  end

  # create manofacturers
  manofacturers = []
  COUNTS[:manofacturers].times do
    manofacturers << Manofacturer.create!(name: Faker::Company.unique.name,
      description: Faker::Company.unique.catch_phrase)
  end

  # create products
  COUNTS[:products].times do
    Product.create! name: Faker::Commerce.unique.product_name,
      price: Faker::Commerce.unique.price,
      categories: categories.sample(rand(1..3)),
      manofacturer: manofacturers.sample,
      seller: sellers.sample
  end
end
