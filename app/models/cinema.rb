class Cinema < MovieGluApi
  attr_accessor :cinema_id, :cinema_name, :address, :address2, :city,
    :postcode, :distance, :logo_url

  def self.nearby(current_account, limit=5)
    # response = connection.get("cinemasNearby/", { n: limit }) do |request|
    #  request.headers["geolocation"] = "39.919404;-104.9908763"
    #  request.headers["device-datetime"] = Time.now.utc.iso8601
    # end
    source_to_collection( test_cinamas_list )
  end


  private

    # in case I reach the 75 quota limit
    def self.test_cinamas_list
      [{"cinema_id"=>10826, "cinema_name"=>"AMC Orchard 12", "address"=>"14653 Orchard Parkway", "address2"=>"", "city"=>"Westminster", "county"=>"Adams", "postcode"=>80023, "lat"=>39.958038, "lng"=>-104.993698, "distance"=>2.6737216856517, "logo_url"=>"https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/Amc_theatres_logo.svg/1200px-Amc_theatres_logo.svg.png"}, {"cinema_id"=>4196, "cinema_name"=>"AMC Westminster Promenade 24", "address"=>"10655 Westminster Boulevard", "address2"=>"", "city"=>"Westminster", "county"=>"Jefferson", "postcode"=>80020, "lat"=>39.889198, "lng"=>-105.070702, "distance"=>4.7179793245408, "logo_url"=>"https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/Amc_theatres_logo.svg/1200px-Amc_theatres_logo.svg.png"}, {"cinema_id"=>49307, "cinema_name"=>"Alamo Drafthouse Cinema - Westminster", "address"=>"8905 Westminster Boulevard", "address2"=>"", "city"=>"Westminster", "county"=>"Jefferson", "postcode"=>80031, "lat"=>39.863892, "lng"=>-105.062698, "distance"=>5.4047863150156, "logo_url"=>"https://s3.drafthouse.com/branding/assets/Primary_Logo/Standard_1color/ADC_Logo_ST_1C_RGB.png"}, {"cinema_id"=>2980, "cinema_name"=>"88 Drive-In Theatre", "address"=>"8780 Rosemary Street", "address2"=>"", "city"=>"Commerce City", "county"=>"Adams", "postcode"=>80022, "lat"=>39.855728, "lng"=>-104.899597, "distance"=>6.5406095882819, "logo_url"=>"https://assets.movieglu.com/chain_logos/us/UK-0-sq.jpg"}, {"cinema_id"=>8058, "cinema_name"=>"AMC Flatiron Crossing 14", "address"=>"61 West Flatiron Circle", "address2"=>"", "city"=>"Broomfield", "county"=>"Broomfield", "postcode"=>80021, "lat"=>39.929722, "lng"=>-105.130898, "distance"=>7.4539322777194, "logo_url"=>"https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/Amc_theatres_logo.svg/1200px-Amc_theatres_logo.svg.png"}]
    end
end

#curl "https://api-gate2.movieglu.com/cinemasNearby/?n=5" -H "geolocation: 39.919404;-104.9908763" -H "api-version: v200" -H "Authorization: Basic Q0lORV8zMDpzT1hiZGZiNjZ5dm8=" -H "x-api-key: B7kYVdTc382DOsDULk6NjkCpUGwil5M8KEbpNOdb" -H "device-datetime: 2019-09-23T10:45:30.147Z" -H "territory: US" -H "client: CINE_30"
