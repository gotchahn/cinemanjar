module FoodsHelper
  def food_pick_put_params(restaurant_id)
    {
      food_pick: {
        restaurant_id: restaurant_id
      }
    }
  end
end
