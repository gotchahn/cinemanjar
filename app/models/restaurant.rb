class Restaurant < ZomatoApi
  attr_accessor :id, :name, :url, :average_cost_for_two, :price_range,
    :thumb, :featured_image, :menu_url, :cuisines, :phone_numbers, :highlights,
    :establishment, :currency, :timings, :photos

  has_one :location, class: ZomatoLocation
  has_one :user_rating, class: ZomatoUserRaiting

  def self.search_for(account, establishment_id, cuisine_id, sort= "raiting")
    params = {
      "cuisines" => cuisine_id,
      "establishment_type" => establishment_id,
      "lat" => account.address.latitude,
      "lon" => account.address.longitude,
      "sort" => sort
    }

    response = connection.get("search", params)

    if response.success?
      source_to_collection( response.body["restaurants"].map{|res| res["restaurant"]})
    else
      []
    end
  end

  def self.find(restaurant_id)
    params = {
      "res_id" => restaurant_id
    }
    response = connection.get("restaurant", params)

    if response.success?
      new( response.body )
    end
  end

  def establishments
    establishment.join(", ")
  end

  def user_pictures
    if photos
      photos.map{ |hash| hash["photo"] }
    else
      []
    end
  end
end
