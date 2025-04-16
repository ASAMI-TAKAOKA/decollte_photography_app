class Store < ApplicationRecord
  belongs_to :brand

  acts_as_list scope: :brand

  validates :name, presence: true, uniqueness: true
  validates :address, presence: true
  validates :phone_number, presence: true
end
