class ZomatoLocation
  include Parseable

  attr_accessor :address, :locality, :city, :latitude, :longitude, :zipcode, :country_id
end
