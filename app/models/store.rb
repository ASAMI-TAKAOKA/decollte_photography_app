class Store < ApplicationRecord
  belongs_to :brand

  acts_as_list scope: :brand # 同じブランド内での並び順を管理

  validates :name, presence: true
  validates :address, presence: true
  validates :phone_number, presence: true
end
