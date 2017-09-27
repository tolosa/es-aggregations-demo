# == Schema Information
#
# Table name: products
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  price           :decimal(, )      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  seller_id       :integer          not null
#  manofacturer_id :integer
#

class Product < ApplicationRecord
  belongs_to :seller
  belongs_to :manofacturer

  validates :name, presence: true
  validates :price, numericality: true, presence: true
  validates :seller, presence: true
  validates :manofacturer, presence: true
end
