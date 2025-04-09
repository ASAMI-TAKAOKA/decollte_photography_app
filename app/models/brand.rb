class Brand < ApplicationRecord
  before_validation :generate_slug, on: :create
  validates :slug, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
  validate :slug_cannot_be_changed, on: :update
  has_many :stores, dependent: :destroy

  # このメソッドを使うことで、IDでなく、slug名でURLを作るための処理が行われる
  def to_param
    slug
  end

  private

  def generate_slug
    if name.present? && slug.blank?
      self.slug = name.parameterize
    end
  end

  def slug_cannot_be_changed
    if slug_changed?
      errors.add(:slug, "は一度登録したら変更できません。")
    end
  end
end
