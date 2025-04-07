class Store < ApplicationRecord
  belongs_to :brand

  acts_as_list scope: :brand

  validates :name, presence: true, uniqueness: true
  validates :address, presence: true
  validates :phone_number, presence: true

  def move(direction)
    case direction
    when :higher
      move_higher
    when :lower
      move_lower
    else
      raise ArgumentError, "Invalid direction: #{direction}"
    end
  end
end
