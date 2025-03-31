class Store < ApplicationRecord
  belongs_to :brand, optional: true

  acts_as_list scope: :brand

  validates :name, presence: true
  validates :address, presence: true
  validates :phone_number, presence: true

  def move_within_brand(direction)
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
