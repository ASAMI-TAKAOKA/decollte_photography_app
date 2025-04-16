class Brand < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  validates :slug, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
  validate :slug_cannot_be_changed, on: :update
  has_many :stores, dependent: :destroy

  private

  def slug_cannot_be_changed
    if slug_changed?
      errors.add(:slug, "は一度登録したら変更できません。")
    end
  end
end
