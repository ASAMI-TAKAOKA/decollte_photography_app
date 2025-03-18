class Brand < ApplicationRecord
  before_validation :generate_slug, on: :create

  has_many :stores, dependent: :destroy

  # このメソッドを使うことで、IDでなく、slug名でURLを作るための処理が行われる
  def to_param
    slug
  end

  validates :slug, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true

  private

  def generate_slug
    self.slug = name.parameterize if slug.blank?
  end
end
