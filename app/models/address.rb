class Address < ApplicationRecord
  belongs_to :account

  validates_presence_of :city
  after_validation :geocode

  def full_address
    address1 = [street, apt_number].join(" ")
    state_postal = [state, postal_code].join(" ")
    [address1, city, state_postal].join(", ")
  end

  def latlng
    "#{latitude};#{longitude}"
  end

  def geocoded?
    [latitude, longitude].all?{ |v| v.present? }
  end

  protected

    def geocode
      return unless [street_changed?, apt_number_changed?, city_changed?].any?

      geocodio = Geocodio::Client.new(Rails.application.config.geocodio_api_key)
      location = geocodio.geocode([full_address])
      geo = location.best

      self.latitude = geo.latitude
      self.longitude = geo.longitude
    end
end
