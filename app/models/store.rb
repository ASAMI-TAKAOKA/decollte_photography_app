class Store < ApplicationRecord
  belongs_to :brand, optional: true

  # ブランドごとの店舗一覧での順番を管理する
  acts_as_list scope: :brand, column: :position

  # 全店舗一覧での順番を管理する
  # before_create により、店舗作成(create)の直前に実行される
  before_create :set_global_position

  validates :name, presence: true
  validates :address, presence: true
  validates :phone_number, presence: true

  private

  # Store.maximum(:global_position).to_i + 1 で、 現在の最大global_positionに1を足して設定
  # 新しく作られた店舗は 一番最後に追加されることになる
  def set_global_position
    self.global_position = Store.maximum(:global_position).to_i + 1
  end
end
