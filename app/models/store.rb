# Store モデル
class Store < ApplicationRecord
  belongs_to :brand, optional: true

  acts_as_list scope: :brand

  validates :name, presence: true
  validates :address, presence: true
  validates :phone_number, presence: true

  # 上に移動
  def move_higher
    super()  # acts_as_list の move_higher メソッドを呼び出し
  end

  # 下に移動
  def move_lower
    super()  # acts_as_list の move_lower メソッドを呼び出し
  end

  # ブランド内で上に移動
  def move_higher_within_brand
    if self.brand.present?
      higher_store = self.brand.stores.where("position < ?", self.position).order(position: :desc).first
      swap_positions(higher_store) if higher_store
    end
  end

  # ブランド内で下に移動
  def move_lower_within_brand
    if self.brand.present?
      lower_store = self.brand.stores.where("position > ?", self.position).order(position: :asc).first
      swap_positions(lower_store) if lower_store
    end
  end

  private

  def swap_positions(other_store)
    self_position = self.position
    self.update(position: other_store.position)
    other_store.update(position: self_position)
  end
end
