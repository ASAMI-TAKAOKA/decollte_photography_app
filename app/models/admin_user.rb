class AdminUser < ApplicationRecord
  has_secure_password  # bcrypt を使ったパスワード認証を有効化
  enum :role, { regular_admin: 0, super_admin: 1 }, default: :regular_admin
  validates :username, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  validates :role, presence: true, inclusion: { in: AdminUser.roles.keys }
  validate :only_one_super_admin, if: :super_admin?

  private

  def only_one_super_admin
    if AdminUser.super_admin.exists? && self.new_record?
      errors.add(:role, "特権管理者はすでに存在しています")
    end
  end
end
