class Establishment < ZomatoApi
  attr_accessor :id, :name

  def self.get_types(account)
    params = {
      "lat" => account.address.latitude,
      "lon" => account.address.longitude
    }
    response = connection.get("establishments", params)

    if response.success?
      source_to_collection( response.body["establishments"].map{|est| est["establishment"]} )
    else
      []
    end
  end
end
