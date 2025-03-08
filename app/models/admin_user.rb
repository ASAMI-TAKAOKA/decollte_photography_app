class AdminUser < ApplicationRecord
  has_secure_password  # bcrypt を使ったパスワード認証を有効化

  # role のデフォルト値を 0 にする
  after_initialize :set_default_role, if: :new_record?

  validates :username, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  validates :role, presence: true, inclusion: { in: [ 0, 1 ] } # 0: 一般管理者, 1: 特権管理者

  private

  def set_default_role
    self.role ||= 0
  end
end
