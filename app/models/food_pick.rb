class FoodPick < ApplicationRecord
  belongs_to :account

  validates_presence_of :restaurant_id, :restaurant_name
end
