class Brand < ApplicationRecord
  has_many :stores

  validates :name, presence: true
end