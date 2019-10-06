class Cuisine < ZomatoApi
  attr_accessor :cuisine_id, :cuisine_name

  def self.get_all(account)
    params = {
      "lat" => account.address.latitude,
      "lon" => account.address.longitude
    }
    response = connection.get("cuisines", params)

    if response.success?
      source_to_collection( response.body["cuisines"].map{|cui| cui["cuisine"]} )
    else
      []
    end
  end
end
