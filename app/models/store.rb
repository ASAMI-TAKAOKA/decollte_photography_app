class Store < ApplicationRecord
  belongs_to :brand

  acts_as_list scope: :brand

  validates :name, presence: true, uniqueness: true
  validates :address, presence: true
  validates :phone_number, presence: true

  def move(direction, scope_type: :brand)
    scoped_stores = case scope_type
                    when :brand then Store.where(brand_id: brand_id).order(:position)
                    when :all then Store.all.order(:position)
                    else raise ArgumentError, "Invalid scope_type: #{scope_type}"
                    end

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
