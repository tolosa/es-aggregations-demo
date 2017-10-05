CATEGORIES_COUNT = SELLERS_COUNT = MANOFACTURERS_COUNT = 8
PRODUCTS_COUNT = 500

Faker::Config.random = Random.new(42)

ActiveRecord::Base.transaction do
  # clears all
  Product.destroy_all
  [Category, Manofacturer, Seller].each(&:delete_all)

  # create categories
  categories = []
  CATEGORIES_COUNT.times do
    categories << Category.create!(name: Faker::Commerce.unique.department(1))
  end

  # create sellers
  sellers = []
  SELLERS_COUNT.times do
    sellers << Seller.create!(first_name: Faker::Name.unique.first_name,
      last_name: Faker::Name.unique.last_name)
  end

  # create manofacturers
  manofacturers = []
  MANOFACTURERS_COUNT.times do
    manofacturers << Manofacturer.create!(name: Faker::Company.unique.name,
      description: Faker::Company.unique.catch_phrase)
  end

  # create products
  PRODUCTS_COUNT.times do
    Product.create! name: Faker::Commerce.unique.product_name,
      price: Faker::Commerce.unique.price,
      categories: categories.sample(rand(1..3)),
      manofacturer: manofacturers.sample,
      seller: sellers.sample
  end
end

# rebuild indexes
Product.import force: true
