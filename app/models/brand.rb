class Brand < ApplicationRecord
  before_validation :generate_slug, on: :create
  has_many :stores, dependent: :destroy
  # 作成時のみ設定可能となり、一度保存すると変更できなくなる。
  # updateメソッドを使っても更新されない。
  attr_readonly :slug

  # このメソッドを使うことで、IDでなく、slug名でURLを作るための処理が行われる
  def to_param
    slug
  end

  validates :slug, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true

  private

  def generate_slug
    if name.present? && slug.blank?
      self.slug = name.parameterize
    end
  end
end
