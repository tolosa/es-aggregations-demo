# == Schema Information
#
# Table name: manofacturers
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Manofacturer < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
end
